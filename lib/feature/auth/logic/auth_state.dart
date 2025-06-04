
part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}
final class AuthInitial extends AuthState {
}

final class SignUpLoading extends AuthState {

}
final class SignInSuccess extends AuthState {
  final LoginResponseModel signInResponse;
  SignInSuccess({required this.signInResponse});
}
final class SignInLoading extends AuthState {
}

final class ObscureText1 extends AuthState {}

final class ObscureText2 extends AuthState {}

final class ChangeCheckboxValue extends AuthState {}
final class SignUpSuccess extends AuthState {
  final RegisterResponseModel signUpResponse;
  SignUpSuccess({required this.signUpResponse});

}


final class SignInFailed extends AuthState {
   final String message;
 SignInFailed({required this.message});
}

final class SignUpFailed extends AuthState {
  final String message;
  SignUpFailed({required this.message});
}
