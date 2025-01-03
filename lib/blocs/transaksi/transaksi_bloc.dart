import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/model/transaksi.dart';
import 'transaksi_event.dart';
import 'transaksi_state.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  final TransaksiApi transaksiApi;
  final _stateController = StreamController<TransaksiState>.broadcast();
  Timer? _pollingTimer;
  Timer? _searchDebounceTimer; // Add debounce timer
  String? _lastUpdated;

  // Store search query
  String? _searchQuery;

  Stream<TransaksiState> get stateStream => _stateController.stream;

  TransaksiBloc({required this.transaksiApi}) : super(TransaksiInitial()) {
    on<FetchTransaksi>(_fetchTransaksis);
    on<UpdateTransaksi>(_updateTransaksis);
    on<SearchTransaksi>(_searchTransaksis);
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
      final response = await transaksiApi.getTransaksi(
          lastUpdated: _lastUpdated, search: _searchQuery);
      _lastUpdated = response['timestamp'];

      final transaksis = List<Transaksi>.from(
        response['data'].map((item) => Transaksi.fromJson(item)),
      );

      final currentState = state;
      if (currentState is! TransaksiLoaded ||
          _hasTransaksiChanged(currentState.transaksis, transaksis)) {
        final newState = TransaksiLoaded(transaksis);
        emit(newState);
        _stateController.add(newState);
      }
    } catch (e) {
      final errorState = TransaksiError(e.toString());
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  bool _hasTransaksiChanged(
      List<Transaksi> oldTransaksi, List<Transaksi> newBookings) {
    if (oldTransaksi.length != newBookings.length) return true;
    for (int i = 0; i < oldTransaksi.length; i++) {
      if (oldTransaksi[i].id != newBookings[i].id) return true;
    }
    return false;
  }

  void _updateTransaksis(UpdateTransaksi event, Emitter<TransaksiState> emit) {
    final newState = TransaksiLoaded(event.transaksis);
    emit(newState);
    _stateController.add(newState);
  }

  // Implement search transaksis logic with debouncing
  void _searchTransaksis( event, Emitter<TransaksiState> emit) {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer?.cancel(); // Cancel any existing timer
    }

    _searchQuery = event.searchQuery;

    // Start a new debounce timer
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(FetchTransaksi()); // Trigger fetch after the debounce delay
    });
  }

  void refreshBookings() {
    add(FetchTransaksi());
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    _searchDebounceTimer?.cancel(); // Cancel the debounce timer
    await _stateController.close();
    return super.close();
  }
}
