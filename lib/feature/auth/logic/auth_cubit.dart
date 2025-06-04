import 'package:bloc/bloc.dart';
import 'package:broker/core/network/dio_factory.dart';
import 'package:broker/feature/auth/data/models/log_in_respone.dart';
import 'package:broker/feature/auth/data/models/register_model.dart';
import 'package:broker/feature/auth/data/models/register_response.dart';
import 'package:broker/feature/auth/data/repo/auth_repo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/helpers/cash_helper.dart';
import '../data/models/login_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
   AuthCubit(AuthService this.authService) : super(AuthInitial());
   final AuthService authService;
  static AuthCubit get(context) => BlocProvider.of(context);
  bool isObscureText1 = true;
  bool isObscureText2 = true;
  bool? isChecked = false;
 String logInPhone="" ;
   String signUpPhone="" ;
 void changeLogInPhone(String newPhone) {
   logInPhone = newPhone;
  // emit(ChangePhone());
 }

   void changeSignUpPhone(String newPhone) {
    signUpPhone = newPhone;
     // emit(ChangePhone());
   }
  void obscureText1() {
    isObscureText1 = !isObscureText1;
    emit(ObscureText1());
  }

  void obscureText2() {
    isObscureText2 = !isObscureText2;
    emit(ObscureText2());
  }

  void changeCheckboxValue(bool newIsChecked) {
    isChecked = newIsChecked;
    emit(ChangeCheckboxValue());
  }

   Future<void> login( LogInModel loginModel) async {
     emit(SignInLoading());
     final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
     if (!connectivityResult.contains(ConnectivityResult.none)) {
       final response = await authService.login(loginModel);
       response.fold(
             (r) => emit(SignInFailed(message: r.message)),
             (r) async{
           // Save sign-in response securely
           CashHelper.setStringSecured(
             key: Keys.signInResponse,
             value: r.toJson(),
           );
           CashHelper.setStringSecured(
             key: Keys.token,
             value: r.token!,
           );
                   await CashHelper.setStringSecured(
  key: Keys.id,
  value: r.user!.id.toString(),
);
print('Saving user ID: ${r.user?.id}');
           DioFactory.setTokenIntoHeaderAfterLogin(r.token);
           emit(SignInSuccess(signInResponse: r));
           print('saved ${r.toJson()}');
           
         },
       );
     } else {
       emit(SignInFailed(message: 'No internet connection.'));
     }
   }
  // Future<void> login( LogInModel loginModel) async {
  //   emit(SignInLoading());
  //   final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  //   if (!connectivityResult.contains(ConnectivityResult.none)) {
  //     final response = await authService.login(loginModel);
  //     response.fold(
  //           (r) => emit(SignInFailed(message: r.errMessage)),
  //           (r) {
  //         // Save sign-in response securely
  //         CashHelper.setStringSecured(
  //           key: Keys.signInResponse,
  //           value: r.toJson(),
  //         );
  //         CashHelper.setStringSecured(
  //           key: Keys.token,
  //           value: r.token!,
  //         );
  //         DioFactory.setTokenIntoHeaderAfterLogin(r.token);
  //         emit(SignInSuccess(signInResponse: r));
  //         print('saved ${r.toJson()}');
  //       },
  //     );
  //   } else {
  //     emit(SignInFailed(message: 'No internet connection.'));
  //   }
  // }



  // Future<void> signUp(RegisterModel signUpModel) async {
  //   emit(SignUpLoading());
  //   final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  //   if (!connectivityResult.contains(ConnectivityResult.none)) {
  //     final response = await authService.register(signUpModel);
  //     response.fold(
  //             (l) => emit(SignUpFailed(message: l.errMessage)),
  //             (r)  {
  //           // Save sign-in response securely
  //           CashHelper.setStringSecured(
  //             key: Keys.signUpResponse,
  //             value: r.toJson(),
  //           );
  //           CashHelper.setStringSecured(
  //             key: Keys.token,
  //             value: r.token,
  //           );
  //           emit(SignUpSuccess(signUpResponse: r));
  //           print('saved ${r.toJson()}');
  //         }
  //     );
  //   } else {
  //     emit(SignUpFailed(message: 'No internet connection.'));
  //   }
  // }
   Future<void> signUp(RegisterModel signUpModel) async {
     emit(SignUpLoading());
     final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
     if (!connectivityResult.contains(ConnectivityResult.none)) {
       final response = await authService.register(signUpModel);
       response.fold(
               (l) => emit(SignUpFailed(message: l.message)),
               (r)  async {

             DioFactory.setTokenIntoHeaderAfterLogin(r.token!);
             CashHelper.setStringSecured(
               key: Keys.signUpResponse,
               value: r.toJson(),
             );
             CashHelper.setStringSecured(
               key: Keys.token,
               value: r.token!,
             );
             await CashHelper.setStringSecured(
  key: Keys.id,
  value: r.user.id.toString(),
);


             emit(SignUpSuccess(signUpResponse: r));
             print('saved ${r.toJson()}');
           }
       );
     } else {
       emit(SignUpFailed(message: 'No internet connection.'));
     }
   }


}
