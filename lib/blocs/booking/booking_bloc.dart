import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/booking_api.dart';
import 'package:rosantibike_mobile/model/booking.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingApi bookingApi;
  final _stateController = StreamController<BookingState>.broadcast();
  Timer? _pollingTimer;
  Timer? _searchDebounceTimer; // Add debounce timer
  String? _lastUpdated;

  // Store search query
  String? _searchQuery;

  Stream<BookingState> get stateStream => _stateController.stream;

  BookingBloc({required this.bookingApi}) : super(BookingInitial()) {
    on<FetchBookings>(_fetchBookings);
    on<UpdateBookings>(_updateBookings);
    on<SearchBookings>(_searchBookings);
    _startPolling();
  }

  void _startPolling() {
    add(FetchBookings());
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      add(FetchBookings());
    });
  }

  Future<void> _fetchBookings(
      FetchBookings event, Emitter<BookingState> emit) async {
    try {
      final response = await bookingApi.getBooking(
          lastUpdated: _lastUpdated, search: _searchQuery);
      _lastUpdated = response['timestamp'];

      final bookings = List<Booking>.from(
        response['data'].map((item) => Booking.fromJson(item)),
      );

      final currentState = state;
      if (currentState is! BookingLoaded ||
          _hasBookingsChanged(currentState.bookings, bookings)) {
        final newState = BookingLoaded(bookings);
        emit(newState);
        _stateController.add(newState);
      }
    } catch (e) {
      final errorState = BookingError(e.toString());
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  bool _hasBookingsChanged(
      List<Booking> oldBookings, List<Booking> newBookings) {
    if (oldBookings.length != newBookings.length) return true;
    for (int i = 0; i < oldBookings.length; i++) {
      if (oldBookings[i].id != newBookings[i].id) return true;
    }
    return false;
  }

  void _updateBookings(UpdateBookings event, Emitter<BookingState> emit) {
    final newState = BookingLoaded(event.bookings);
    emit(newState);
    _stateController.add(newState);
  }

  // Implement search bookings logic with debouncing
  void _searchBookings(SearchBookings event, Emitter<BookingState> emit) {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer?.cancel(); // Cancel any existing timer
    }

    _searchQuery = event.searchQuery;

    // Start a new debounce timer
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(FetchBookings()); // Trigger fetch after the debounce delay
    });
  }

  void refreshBookings() {
    add(FetchBookings());
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    _searchDebounceTimer?.cancel(); // Cancel the debounce timer
    await _stateController.close();
    return super.close();
  }
}
