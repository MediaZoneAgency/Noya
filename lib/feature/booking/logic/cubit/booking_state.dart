part of 'booking_cubit.dart';

@immutable
sealed class BookingState {}


class BookingInitial extends BookingState {}

class GetUserBookingsLoading extends BookingState {}

class GetUserBookingsSuccess extends BookingState {
  final List<BookingModel> bookings;
  GetUserBookingsSuccess(this.bookings);
}
class GetUserBookingsListSuccess extends BookingState {
  final List<BookingModel> bookings;
  GetUserBookingsListSuccess(this.bookings);
}
class GetUserBookingsError extends BookingState {
  final String error;
  GetUserBookingsError(this.error);
}
class GetUserBookingsDetailsSuccess extends BookingState {
  final List<UnitModel> units;
  GetUserBookingsDetailsSuccess(this.units);
}
