import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/booking_api.dart';
import 'package:rosantibike_mobile/model/booking.dart';
import 'package:rosantibike_mobile/services/notification_service.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingApi bookingApi;
  final NotificationService notificationService;
  final _stateController = StreamController<BookingState>.broadcast();
  Timer? _pollingTimer;
  Timer? _searchDebounceTimer;
  String? _lastUpdated;
  String? _searchQuery;
  List<Booking>? _previousBookings;

  Stream<BookingState> get stateStream => _stateController.stream;

  BookingBloc({
    required this.bookingApi,
    required this.notificationService,
  }) : super(BookingInitial()) {
    on<FetchBookings>(_fetchBookings);
    on<UpdateBookings>(_updateBookings);
    on<SearchBookings>(_searchBookings);
    on<DeleteBooking>(_deleteBooking);
    on<ProcessNewBooking>(_processNewBooking);

    print('BookingBloc initialized'); // Debug print
    _startPolling();
  }

  void _startPolling() {
    print('Starting polling for bookings'); // Debug print
    add(FetchBookings());
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      print('Polling timer triggered'); // Debug print
      add(FetchBookings());
    });
  }

  Future<void> _fetchBookings(
      FetchBookings event, Emitter<BookingState> emit) async {
    try {
      print('Fetching bookings...'); // Debug print
      emit(BookingLoading());

      final response = await bookingApi.getBooking(
        lastUpdated: _lastUpdated,
        search: _searchQuery,
      );

      print('Response received: ${response.toString()}'); // Debug print

      _lastUpdated = response['timestamp'];

      final bookings = List<Booking>.from(
        response['data'].map((item) => Booking.fromJson(item)),
      );

      print('Number of bookings fetched: ${bookings.length}'); // Debug print

      if (_previousBookings != null) {
        print('Previous bookings exist, checking for new ones'); // Debug print
        _checkForNewBookings(bookings);
      } else {
        print('No previous bookings to compare'); // Debug print
      }

      _previousBookings = List.from(bookings);

      final currentState = state;
      if (currentState is! BookingLoaded ||
          _hasBookingsChanged(currentState.bookings, bookings)) {
        print('State needs update'); // Debug print
        final newState = BookingLoaded(bookings);
        emit(newState);
        _stateController.add(newState);
      }
    } catch (e) {
      print('Error in _fetchBookings: $e'); // Debug print
      final errorState =
          BookingError('Error fetching bookings: ${e.toString()}');
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  void _checkForNewBookings(List<Booking> newBookings) {
    print('Checking for new bookings...'); // Debug print
    for (var booking in newBookings) {
      bool isNew = _previousBookings == null ||
          !_previousBookings!.any((old) => old.id == booking.id);
      print('Checking booking ID: ${booking.id}, isNew: $isNew'); // Debug print
      if (isNew) {
        print('New booking found! ID: ${booking.id}'); // Debug print
        add(ProcessNewBooking(booking));
      }
    }
  }

  Future<void> _processNewBooking(
      ProcessNewBooking event, Emitter<BookingState> emit) async {
    try {
      print('Processing new booking notification...'); // Debug print
      print('Booking details:'); // Debug print
      print('ID: ${event.booking.id}');
      print('Nama Penyewa: ${event.booking.namaPenyewa}');
      print('Nopol: ${event.booking.nopol}');

      await notificationService.showTransactionNotification(
        title: 'Booking Baru #${event.booking.id}',
        body: 'Booking baru untuk ${event.booking.namaPenyewa}\n'
            'Motor: ${event.booking.nopol}',
        transactionId: event.booking.id.toString(),
        motorType: event.booking.nopol,
      );
      print('Notification sent successfully'); // Debug print
    } catch (e) {
      print('Error in _processNewBooking: $e'); // Debug print
      print('Stack trace: ${StackTrace.current}'); // Debug print
    }
  }

  bool _hasBookingsChanged(
      List<Booking> oldBookings, List<Booking> newBookings) {
    if (oldBookings.length != newBookings.length) return true;

    final sortedOld = List<Booking>.from(oldBookings)
      ..sort((a, b) => a.id.compareTo(b.id));
    final sortedNew = List<Booking>.from(newBookings)
      ..sort((a, b) => a.id.compareTo(b.id));

    for (int i = 0; i < sortedOld.length; i++) {
      if (sortedOld[i].id != sortedNew[i].id ||
          sortedOld[i].status != sortedNew[i].status) {
        return true;
      }
    }
    return false;
  }

  void _updateBookings(UpdateBookings event, Emitter<BookingState> emit) {
    final newState = BookingLoaded(event.bookings);
    emit(newState);
    _stateController.add(newState);
  }

  void _searchBookings(SearchBookings event, Emitter<BookingState> emit) {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer?.cancel();
    }

    _searchQuery = event.searchQuery;

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(FetchBookings());
    });
  }

  Future<void> _deleteBooking(
      DeleteBooking event, Emitter<BookingState> emit) async {
    try {
      emit(BookingLoading());
      await bookingApi.deleteBooking(event.bookingId);
      add(FetchBookings());
    } catch (e) {
      emit(BookingError('Failed to delete booking: ${e.toString()}'));
    }
  }

  void refreshBookings() {
    _lastUpdated = null;
    add(FetchBookings());
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    _searchDebounceTimer?.cancel();
    await _stateController.close();
    return super.close();
  }
}
