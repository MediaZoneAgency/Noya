import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_constant.dart';
import '../../../home/data/models/unit_model.dart';


class SearchRepo {
  SearchRepo(this.dio);
  final Dio dio;

  Future<Either<ApiErrorModel, List<UnitModel>>> getSearch(
      {required String search,
      required double minPrice ,
      required double maxPrice,
        // required double room,
        // required double bathrooms,
      required String categoryName,
        // required double price,
        // required double size
      }) async {
    try {
      //?search=rice&min_price=10&max_price=50&category?name=humanitarian
      Response response = await dio.get(NetworkConstant.search, queryParameters: {
        'search': search,
        'type': categoryName,
        // 'rooms':room,
        // 'bathrooms':bathrooms,
        // 'price':price,
        // 'size':size


      });
      List<UnitModel> products = (response.data as List)
          .map((item) => UnitModel.fromMap(item))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }
}