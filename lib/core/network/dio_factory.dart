import 'package:broker/core/network/network_constant.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;
  static Dio? dioChat;
  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 60);

    if (dio == null) {
      dio = Dio(

        BaseOptions(
          baseUrl: NetworkConstant.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      );
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut..options;
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static Dio getDio2() {
    Duration timeOut = const Duration(seconds: 60);

    if (dioChat == null) {
      dioChat = Dio(

        BaseOptions(
          baseUrl: NetworkConstant.baseUrl1,
          headers: {'Content-Type': 'application/json'},
        ),
      );
      dioChat!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut..options;
      addDioInterceptor();
      return dioChat!;
    } else {
      return dioChat!;
    }
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      'Authorization': 'Bearer $token',
    };
  }
  static void removeTokenIntoHeaderAfterLogout() {
    dio?.options.headers = {
      'Authorization': '',
    };
  }
}
