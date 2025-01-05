import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/model/transaksi.dart';
import 'package:rosantibike_mobile/services/notification_service.dart';
import 'transaksi_event.dart';
import 'transaksi_state.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  final TransaksiApi transaksiApi;
  final NotificationService notificationService;
  final _stateController = StreamController<TransaksiState>.broadcast();
  Timer? _pollingTimer;
  Timer? _searchDebounceTimer;
  String? _lastUpdated;
  String? _searchQuery;
  List<Transaksi>? _previousTransaksis;

  Stream<TransaksiState> get stateStream => _stateController.stream;

  TransaksiBloc({
    required this.transaksiApi,
    required this.notificationService,
  }) : super(TransaksiInitial()) {
    on<FetchTransaksi>(_fetchTransaksis);
    on<UpdateTransaksi>(_updateTransaksis);
    on<SearchTransaksi>(_searchTransaksis);
    on<DeleteTransaksi>(_deleteTransaksi);
    on<ProcessNewTransaksi>(_processNewTransaksi);

    _startPolling();
  }

  void _startPolling() {
    add(FetchTransaksi());
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      add(FetchTransaksi());
    });
  }

  Future<void> _fetchTransaksis(
      FetchTransaksi event, Emitter<TransaksiState> emit) async {
    try {
      emit(TransaksiLoading());

      final response = await transaksiApi.getTransaksi(
        lastUpdated: _lastUpdated,
        search: _searchQuery,
      );

      _lastUpdated = response['timestamp'];

      final transaksis = List<Transaksi>.from(
        response['data'].map((item) => Transaksi.fromJson(item)),
      );

      if (_previousTransaksis != null) {
        _checkForNewTransaksis(transaksis);
      }
      _previousTransaksis = List.from(transaksis);

      final currentState = state;
      if (currentState is! TransaksiLoaded ||
          _hasTransaksiChanged(currentState.transaksis, transaksis)) {
        final newState = TransaksiLoaded(transaksis);
        emit(newState);
        _stateController.add(newState);
      }
    } catch (e) {
      final errorState =
          TransaksiError('Error fetching transactions: ${e.toString()}');
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  void _checkForNewTransaksis(List<Transaksi> newTransaksis) {
    for (var transaksi in newTransaksis) {
      bool isNew = !_previousTransaksis!.any((old) => old.id == transaksi.id);
      if (isNew) {
        add(ProcessNewTransaksi(transaksi));
      }
    }
  }

  Future<void> _processNewTransaksi(
      ProcessNewTransaksi event, Emitter<TransaksiState> emit) async {
    try {
      // Menggunakan parameter yang sesuai dengan yang didefinisikan di NotificationService
      await notificationService.showTransactionNotification(
        title: 'Transaksi Baru #${event.transaksi.id}',
        body: 'Transaksi baru untuk ${event.transaksi.namaPenyewa}\n'
            'Motor: ${event.transaksi.nopol}',
        transactionId: event.transaksi.id.toString(),
        motorType: event.transaksi.nopol,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  bool _hasTransaksiChanged(
      List<Transaksi> oldTransaksi, List<Transaksi> newTransaksis) {
    if (oldTransaksi.length != newTransaksis.length) return true;

    final sortedOld = List<Transaksi>.from(oldTransaksi)
      ..sort((a, b) => a.id.compareTo(b.id));
    final sortedNew = List<Transaksi>.from(newTransaksis)
      ..sort((a, b) => a.id.compareTo(b.id));

    for (int i = 0; i < sortedOld.length; i++) {
      if (sortedOld[i].id != sortedNew[i].id ||
          sortedOld[i].status != sortedNew[i].status) {
        return true;
      }
    }
    return false;
  }

  void _updateTransaksis(UpdateTransaksi event, Emitter<TransaksiState> emit) {
    final newState = TransaksiLoaded(event.transaksis);
    emit(newState);
    _stateController.add(newState);
  }

  void _searchTransaksis(SearchTransaksi event, Emitter<TransaksiState> emit) {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer?.cancel();
    }

    _searchQuery = event.searchQuery;

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(FetchTransaksi());
    });
  }

  Future<void> _deleteTransaksi(
      DeleteTransaksi event, Emitter<TransaksiState> emit) async {
    try {
      emit(TransaksiLoading());

      await transaksiApi.deleteTransaksi(event.transaksiId);

      add(FetchTransaksi());
    } catch (e) {
      emit(TransaksiError('Failed to delete transaction: ${e.toString()}'));
    }
  }

  void refreshTransaksis() {
    _lastUpdated = null;
    add(FetchTransaksi());
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    _searchDebounceTimer?.cancel();
    await _stateController.close();
    return super.close();
  }
}
