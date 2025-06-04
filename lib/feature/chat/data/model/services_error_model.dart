import '../../../../core/error/error_model.dart';

class ServerFailure extends ApiErrorModel {
  final String message;

  ServerFailure(this.message) : super(message: '');

  @override
  String toString() => 'ServerFailure: $message';
}
