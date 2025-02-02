import 'package:equatable/equatable.dart';
import 'package:rosantibike_mobile/model/booking.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBookings extends BookingEvent {}

class UpdateBookings extends BookingEvent {
  final List<Booking> bookings;

  UpdateBookings(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class SearchBookings extends BookingEvent {
  final String searchQuery;

  SearchBookings(this.searchQuery);
}

class DeleteBooking extends BookingEvent {
  final int bookingId;

  DeleteBooking(this.bookingId);
}

class ProcessNewBooking extends BookingEvent {
  final Booking booking;

  ProcessNewBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}
