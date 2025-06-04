import 'package:broker/core/network/network_constant.dart';
import 'package:broker/feature/auth/data/models/log_in_respone.dart';
import 'package:broker/feature/auth/data/models/login_model.dart';
import 'package:broker/feature/auth/data/models/register_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/error/failure.dart';
import '../models/register_response.dart';

class AuthService {
  final Dio _dio ;

  AuthService(this._dio);


  Future<Either<ApiErrorModel, RegisterResponseModel>> register(RegisterModel registerModel) async {
    try {
      final response = await _dio.post(NetworkConstant.regsit, data: registerModel.toMap());


      return Right(RegisterResponseModel.fromMap(response.data));
    } catch (e) {
      return left(ApiErrorHandler.handle(e));

    }
  }



  // Login API Call with Status Code Handling
  //  static Future<void> login(LogInModel loginModal) async {
  //   try {
  //     print(loginModal.phoneNumber);
  //     print(loginModal.password);
  //     print(loginModal.email);
  //
  //     final response = await _dio.post('/login', data:
  //       loginModal.toMap()
  //     );
  //
  //     if (response.statusCode == 200) {
  //      // Fluttertoast.showToast(msg: )
  //       print('Login successful: ${response.data}');
  //     } else {
  //       print('Login failed with status code: ${response.statusCode}');
  //     }
  //   }  on DioException catch(e) {
  //     if (e.response != null) {
  //       _handleError(e.response!.statusCode!, e.response!.data);
  //     } else {
  //       print('Error sending request: ${e.message}');
  //     }
  //   }
  // }
 //
 //   Future<Either<ApiErrorHandler, LoginResponseModel>> login(LogInModel loginModel) async {
 //   try {
 //     final response = await _dio.post(NetworkConstant.login, data: loginModel.toMap());
 //
 //     if (response.statusCode == 200 || response.statusCode == 201) {
 //       print("rrrrrrrr");
 //       return Right(LoginResponseModel.fromMap(response.data));
 //     } else {
 //       // Handle unexpected status codes if any
 //       print("hhhhhhhhh");
 //       return left(ServerFailure('Unexpected status code: ${response.statusCode}'));
 //     }
 //   } catch (e) {
 //     print("llllllllll");
 //
 //     if (e is DioException) {
 //       return left(ServerFailure.fromDioError(e));
 //     }
 //     return left(ServerFailure(e.toString()));
 //   }
 //
 //
 // }
  Future<Either<ApiErrorModel, LoginResponseModel>> login(LogInModel loginModel) async {
    try {
      final response = await _dio.post(NetworkConstant.login, data: loginModel.toMap());


      return Right(LoginResponseModel.fromMap(response.data));

    } catch (e) {
      return left(ApiErrorHandler.handle(e));

    }
  }

 // Logout API Call with Status Code Handling
  Future<void> logout(String token) async {
    try {
      final response = await _dio.post('/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        print('Logout successful: ${response.data}');
      } else {
        print('Logout failed with status code: ${response.statusCode}');
      }
    }  on DioException catch (e) {
      if (e.response != null) {
        _handleError(e.response!.statusCode!, e.response!.data);
      } else {
        print('Error sending request: ${e.message}');
      }
    }
  }

  // A helper function to handle errors based on status code
 static void _handleError(int statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        print('Bad Request: $data');
        break;
      case 401:
        print('Unauthorized: Please check your credentials.');
        break;
      case 403:
        print('Forbidden: You do not have access.');
        break;
      case 404:
        print('Not Found: The requested resource does not exist.');
        break;
      case 500:
        print('Internal Server Error: Something went wrong on the server.');
        break;
      default:
        print('Received unknown error with status code $statusCode: $data');
    }
  }
}
