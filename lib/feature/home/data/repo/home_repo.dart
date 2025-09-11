import 'dart:developer';

import 'package:broker/core/error/error_model.dart';
import 'package:broker/core/network/network_constant.dart';
import 'package:broker/feature/booking/data/models/booking,odel.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/cash_helper.dart';

class HomeRepo {
  final Dio _dio;

  HomeRepo(this._dio);

  Future<Either<ApiErrorModel, List<UnitModel>>> fetchUnits() async {
    List<UnitModel> units = [];
    try {
        var response = await _dio.get(NetworkConstant.unitsTypes);

      for (var item in response.data) {

        units.add(UnitModel.fromMap(item));
        log('no');
      }
      return right(units);
    } catch (e) {

      return left(ApiErrorHandler.handle(e));
    }
  }
  Future<Either<ApiErrorModel, List<UnitModel>>> fetchUnitsTypes(String type) async {

    List<UnitModel> units = [];
    try {
      var response = await _dio.get(NetworkConstant.unitsTypes,queryParameters: {'type': type});

      for (var item in response.data) {
        units.add(UnitModel.fromMap(item));
      }
      return Right(units);
    } catch (e) {

      return left(ApiErrorHandler.handle(e));
    }

  }  Future<Either<ApiErrorModel, List<BookingModel>>> fetchUserBookings() async {
    try {
      // 1. Retrieve the token from local storage
      final token = await CashHelper.getStringSecured(key: Keys.token);

      if (token == null) {
        // Handle case where user is not logged in
        return Left(ApiErrorModel(message: "User not authenticated."));
      }
      
      // 2. Add the token to the request options
      final response = await _dio.get(
        NetworkConstant.userBookings,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<dynamic> bookingData = response.data['data']['bookings'];
      
      final List<BookingModel> bookings = bookingData
          .map((bookingJson) => BookingModel.fromJson(bookingJson))
          .toList();
          
      return Right(bookings);

    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }Future<UnitModel> fetchUnitById(int unitId) async {
  final url = 'https://noyaai.com/api/units/$unitId';

  try {
    // استخدم نسخة _dio التي تم تهيئتها بالتوكن
    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return UnitModel.fromMap(response.data);
    } else {
      throw Exception('Failed to load unit details. Status code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    print("Error in fetchUnitById for unit $unitId: $e");
    print("Response data: ${e.response?.data}"); // هذا سيطبع الـ HTML إذا حدث الخطأ مرة أخرى
    rethrow; // أعد إطلاق الخطأ ليتم التعامل معه في الـ Cubit
  }
}
}


