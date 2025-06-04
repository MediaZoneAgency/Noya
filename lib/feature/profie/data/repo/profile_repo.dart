import 'package:broker/core/error/error_model.dart';
import 'package:broker/core/network/network_constant.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';


import '../../../../core/error/failure.dart';
import '../../../../core/helpers/cash_helper.dart';
import '../models/profile_model.dart';

class ProfileRepo {
  final Dio _dio;

  ProfileRepo(this._dio);

 Future<Either<ApiErrorModel, ProfileModel>> fetchProfile() async {
  String token = await CashHelper.getStringSecured(key: Keys.token);
  
  try {
    var response = await _dio.get(
      NetworkConstant.profile,
      options: Options(
        headers: {
      'Authorization': 'Bearer $token',
  'Accept': 'application/json',
        },
          followRedirects: false,
    validateStatus: (status) {
      return status != null && status < 500;
    },
      ),
    );
    
    return right(ProfileModel.fromMap(response.data));
  } catch (e) {
    print(e);
    return left(ApiErrorHandler.handle(e));
  }
}

  Future<Either<ApiErrorModel,String>> deletAccount() async {
    try {
      Response response = await _dio.delete(

        NetworkConstant.deleteAccount,
      );
      return Right(response
          .data["message"]); // Assuming the response has the profile dat
    } catch (e) {
     // log(e.toString());
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
