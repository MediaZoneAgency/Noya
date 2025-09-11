import 'package:broker/core/di/dependency_inj.dart';
import 'package:broker/feature/auth/logic/auth_cubit.dart';
import 'package:broker/feature/auth/ui/screen/forget_password.dart';

import 'package:broker/feature/auth/ui/screen/signup_screen.dart';
import 'package:broker/feature/booking/logic/cubit/booking_cubit.dart';
import 'package:broker/feature/booking/ui/screen/booking_screen.dart';
import 'package:broker/feature/chat/logic/chat_cubit.dart';
import 'package:broker/feature/chat/ui/screen/voice_chat_screen.dart';
import 'package:broker/feature/home/ui/screen/home_screen.dart';
import 'package:broker/feature/like/logic/fav_cubit.dart';

import 'package:broker/feature/nav_bar/logic/nav_bar_cubit.dart';
import 'package:broker/feature/nav_bar/ui/navigation_bar.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/profie/ui/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/ui/screen/login_screen.dart';
import '../../feature/auth/ui/screen/phone_recovery.dart';
import '../../feature/auth/ui/screen/reset_password.dart';
import '../../feature/chat/ui/screen/ai_chat_screen.dart';
import '../../feature/home/data/models/unit_model.dart';
import '../../feature/home/logic/home_cubit.dart';
import '../../feature/like/ui/screen/like_screen.dart';
import '../../feature/search/logic/search_cubit.dart';
import '../../feature/search/ui/screen/search_result_screen.dart';
import '../../feature/splash/view/splashview.dart';
import '../../feature/unitDetails/ui/screen/unit_details_screen.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    //final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
        );
   case Routes.wishListScreen:
        return MaterialPageRoute(
    
          builder: (_) =>MultiBlocProvider(
              providers: [
    
                BlocProvider<ProfileCubit>.value(
                  value: getIt<ProfileCubit>(),
                ),
                BlocProvider<FavCubit>.value(
                  value: getIt<FavCubit>(),
                ),
              ], 
                   child: const LikeScreenWithDrawer())
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => getIt<AuthCubit>(),
                child: SignUpScreen(),
              ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider<HomeCubit>.value(
                value: getIt<HomeCubit>(),
                child: HomeScreen(),
              ),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) =>
          BlocProvider<ProfileCubit>.value(
            value: getIt<ProfileCubit>(),
            child: ProfileScreen(),
          ),
        );

      case Routes.navBarScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => getIt<NavBarCubit>(),
                child: const NavigationBarApp()
              ),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => getIt<AuthCubit>(),
                child: LoginScreen(),
              ),
        );
         case Routes.AiChatScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>.value(value: getIt<HomeCubit>()),
              BlocProvider<FavCubit>.value(value: getIt<FavCubit>()),
              BlocProvider<ChatCubit>.value(value: getIt<ChatCubit>()),
              BlocProvider<ProfileCubit>.value(value: getIt<ProfileCubit>()),
            ],
            // استخدم الـ Widget الجديد الذي يحتوي على ZoomDrawer
            child: const AiChatRoot(),
          ),
        );
      
    case Routes.BookingScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>.value(value: getIt<HomeCubit>()),
              BlocProvider<FavCubit>.value(value: getIt<FavCubit>()),
              BlocProvider<BookingCubit>.value(value: getIt<BookingCubit>()),
              BlocProvider<ProfileCubit>.value(value: getIt<ProfileCubit>()),
            ],
            // استخدم الـ Widget الجديد الذي يحتوي على ZoomDrawer
            child: const BookingsScreenWithDrawer(),
          ),
        );
//  case Routes.homeScreen:
//         return MaterialPageRoute(

//     builder: (_) =>MultiBlocProvider(
//         providers: [
          // BlocProvider<HomeCubit>.value(
          //   value: getIt<HomeCubit>(),
          // ),
//           BlocProvider<ProductCubit>.value(
//             value: getIt<ProductCubit>(),
//           ),
//           BlocProvider<CartCubit>.value(
//             value: getIt<CartCubit>(),
//           ),
//         ], child: const HomeScreen()),
//          );
      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordScreen(),
        );
      case Routes.phoneRecovery:
        return MaterialPageRoute(
          builder: (_) => const PhoneRecoveryScreen(),
        );

      case Routes.resetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => const ResetPassword(),
        );
      case Routes.unitDetailsScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => getIt<AuthCubit>(),
                child: UnitDetailsScreen(unit: settings.arguments as UnitModel,),
              ),
        );
      case Routes.resultScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(
                value:  getIt<SearchCubit>(),
                child: SearchResultScreen(),
              ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}