import 'dart:developer';

import 'package:broker/core/error/error_model.dart';
import 'package:broker/core/network/network_constant.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

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

  }


}


