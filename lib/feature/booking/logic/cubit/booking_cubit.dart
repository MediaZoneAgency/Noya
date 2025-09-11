import 'package:bloc/bloc.dart';
import 'package:broker/feature/booking/data/models/booking,odel.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:broker/feature/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final HomeRepo _bookingRepo;
  List<BookingModel> userBookings = [];
  List<BookingModel> rawBookings = [];

  // ✅ This new list will hold the full UnitModel details for display
  List<UnitModel> bookedUnitsDetails = [];
  BookingCubit(this._bookingRepo) : super(BookingInitial());

 Future<void> getUserBookingsAndDetails() async {
    emit(GetUserBookingsLoading());
    final bookingResult = await _bookingRepo.fetchUserBookings();

    bookingResult.fold(
      (failure) {
        emit(GetUserBookingsError(failure.message ?? 'Failed to fetch bookings'));
      },
      (bookings) async {
        rawBookings = bookings;
        // Optional: emit the first success state
        emit(GetUserBookingsListSuccess(bookings)); 
        
        if (bookings.isEmpty) {
          bookedUnitsDetails = [];
          // ✅ Emit the new success state with an empty list
          emit(GetUserBookingsDetailsSuccess([])); 
          return;
        }

        // هذا هو الكود الجديد والمبسط الذي ستضعه مكان الكود القديم
        try {
          final List<UnitModel> fetchedUnits = [];

          // سنمر على كل حجز ونجلب تفاصيله بشكل فردي
          for (var booking in bookings) {
            try {
              // نستدعي الدالة المبسطة التي ترجع UnitModel مباشرة
              final unit = await _bookingRepo.fetchUnitById(booking.propertyId);
              fetchedUnits.add(unit);
            } catch (e) {
              // إذا فشل طلب واحد فقط، نطبع الخطأ ونكمل للباقي
              print('Could not fetch details for unit ${booking.propertyId}: $e');
            }
          }

          // بعد انتهاء الـ loop، نرسل قائمة الوحدات التي نجحنا في جلبها
          bookedUnitsDetails = fetchedUnits;
          emit(GetUserBookingsDetailsSuccess(fetchedUnits));

        } catch (e) {
          // هذا الـ catch سيعمل في حالة حدوث خطأ كارثي غير متوقع
          emit(GetUserBookingsError('An unexpected error occurred while fetching details.'));
        }
      },
    );
  }

}