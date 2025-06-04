
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/home/logic/home_cubit.dart';
import '../../feature/home/ui/screen/home_screen.dart';

import '../../feature/nav_bar/logic/nav_bar_cubit.dart';
import '../../feature/nav_bar/ui/navigation_bar.dart';

import '../../feature/search/logic/search_cubit.dart';
import '../../feature/search/ui/screen/search_result_screen.dart';
import '../../feature/search/ui/screen/search_screen.dart';

import '../../feature/splash/view/splashview.dart';

import '../../feature/splash/view/start_screen.dart';
import '../di/dependency_inj.dart';
import '../loclization/localization_cubit.dart';
import '../utils/routes.dart';


class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    //final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
         return MaterialPageRoute(
         builder: (_) => const SplashView(),
        );
      case Routes.initialScreen:
        return MaterialPageRoute(
          builder: (_) =>  IntroScreen(),
        );
    //   //
    //   case Routes.signUpScreen:
    //  return MaterialPageRoute(
    //      builder: (_) =>
    //          BlocProvider(
    //           create: (context) => getIt<SignUpCubit>(),
    //          child: SignUpScreen(),
    //        ),
    //     );
    //   case Routes.homeScreen:
    //     return MaterialPageRoute(
    //
    // builder: (_) =>MultiBlocProvider(
    //     providers: [
    //       BlocProvider<HomeCubit>.value(
    //         value: getIt<HomeCubit>(),
    //       ),
    //       BlocProvider<ProductCubit>.value(
    //         value: getIt<ProductCubit>(),
    //       ),
    //       BlocProvider<CartCubit>.value(
    //         value: getIt<CartCubit>(),
    //       ),
    //     ], child: const HomeScreen()),
    //      );
    //   case Routes.categoriesScreen:
    //     return MaterialPageRoute(
    //         builder: (_)=>
    //             BlocProvider(
    //               create: (context) => getIt<HomeCubit>(),
    //               child:CategoriesScreen(),
    //             ),
    //     );
      // case Routes.girdviewScreen:
      //   return MaterialPageRoute(
      //     builder: (_)=>
      //         BlocProvider(
      //           create: (context) => getIt<ProductCubit>(),
      //           child: CoursesGirdview(),
      //         ),
      //   );

        // case Routes.girdviewScreen
        // return MaterialPageRoute(
        //     builder:(_)=>
        //         BlocProvider.value(value:
        //         getIt<ProductCubit>,
        //         child: CoursesGirdviewScreen(),)
        // );
      case Routes.navBarScreen:
        return MaterialPageRoute(
        builder: (_) =>
               const NavigationBarApp(),
         );
       // case Routes.voiceChatScreen:
       //   return MaterialPageRoute(
       //    builder: (_) =>
       //         BlocProvider(
       //           create: (context) => getIt<SignInCubit>(),
       //          child: SignInScreen(),
       //         ),
       //   );
    //   case Routes.cartScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider(
    //             create: (context) => getIt<CartCubit>(),
    //             child: CartScreen(),
    //           ),
    //     );
    //   case Routes.checkoutScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider(
    //             create: (context) => getIt<ProductCubit>(),
    //             child: CheckoutScreen(),
    //           ),
    //     );
    //
    //   case Routes.wishListScreen:
    //     return MaterialPageRoute(
    //
    //       builder: (_) =>MultiBlocProvider(
    //           providers: [
    //
    //             BlocProvider<ProfileCubit>.value(
    //               value: getIt<ProfileCubit>(),
    //             ),
    //             BlocProvider<FavCubit>.value(
    //               value: getIt<FavCubit>(),
    //             ),
    //           ], child: const WishListScreen()),
    //     );
    //   case Routes.accountInfoScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //          BlocProvider.value(
    //             value: getIt<ProfileCubit>(),
    //             child: AccountInfoScreen(),
    //           ),
    //     );
    //   case Routes.coursesGridViewScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>MultiBlocProvider(providers: [
    //         BlocProvider.value(
    //              value: getIt<ProductCubit>()
    //         ),
    //         BlocProvider.value(
    //             value: getIt<FavCubit>()
    //         ),
    //         BlocProvider<ProfileCubit>.value(
    //           value: getIt<ProfileCubit>(),
    //         ),
    //       ],
    //           child:CoursesGirdviewScreen())
    //
    //     );
    //   case Routes.editAccountInfoScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider.value(
    //             value: getIt<ProfileCubit>(),
    //             child: EditAccountInfoScreen(),
    //           ),
    //     );
    //   case Routes.OTPScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider(
    //             create: (context) => getIt<SignInCubit>(),
    //             child: VerifyCode(),
    //           ),
    //     );
    //
    //   case Routes.forgetPasswordScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider(
    //             create: (context) => getIt<SignInCubit>(),
    //             child: ForgetPasswordScreen(),
    //           ),
    //     );
    //   case Routes.resetPasswordScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider(
    //             create: (context) => getIt<SignInCubit>(),
    //             child: ResetPasswordScreen(),
    //           ),
    //     );
    //
    //    case Routes.fieldScreen:
    //      return MaterialPageRoute(
    //      builder: (_) =>  FieldsScreen(),
    //    );
    //   case Routes.typeFieldsScreen:
    //     return MaterialPageRoute(
    //       builder: (_) => TypeFieldsScreen(type: '',),
    //     );
    //   //
    //
    //   case Routes.DetailsScreen:
    //     return MaterialPageRoute(
    //
    //       builder: (_) =>MultiBlocProvider(
    //           providers: [
    //
    //             BlocProvider<ProfileCubit>.value(
    //               value: getIt<ProfileCubit>(),
    //             ),
    //             BlocProvider<FavCubit>.value(
    //               value: getIt<FavCubit>(),
    //             ),
    // BlocProvider(
    // create: (context) => getIt<ProductCubit>()),
    //           ], child:  DetailsScreen( settings.arguments as ProductModel),
    //       ),
    //     );
    //   // case Routes.DetailsScreen:
    //   //    return MaterialPageRoute(
    //   //     builder: (_) =>
    //   //         BlocProvider(
    //   //           create: (context) => getIt<ProductCubit>(),
    //   //           child: DetailsScreen( settings.arguments as ProductModel),
    //   //         ),
    //   //   );
    //   // case Routes.girdviewScreen:
    //   //   return MaterialPageRoute(
    //   //     builder: (_) =>
    //   //         BlocProvider(
    //   //           create: (context) => getIt<ProductCubit>(),
    //   //           child: CoursesGirdview( settings.arguments as String),
    //   //         ),
    //   //   );
    //   case Routes.girdviewScreen:
    //     return MaterialPageRoute(
    //       builder: (_)=> MultiBlocProvider(
    //         providers: [
    //       BlocProvider.value(
    //       value:  getIt<ProductCubit>()),
    //           BlocProvider<FavCubit>.value(
    //             value: getIt<FavCubit>(),
    //           ),
    //           BlocProvider<ProfileCubit>.value(
    //             value: getIt<ProfileCubit>(),
    //           ),
    //         ],
    //         child:CoursesGirdview( settings.arguments as String ?? 'DefaultArgument'),
    //       ),
    //
    //     );
    //   case Routes.profileScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //           BlocProvider<ProfileCubit>.value(
    //             value: getIt<ProfileCubit>(),
    //             child: ProfileScreen(),
    //           )
    //     );
    //
    //   case Routes.settingsScreen:
    //     return MaterialPageRoute(
    //       builder: (_) =>
    //          BlocProvider.value(
    //             value: getIt<ProfileCubit>(),
    //             child:const SettingScreen() ,
    //           ),
    //     );
    //
    //
    //
    //
    return null;
    }
  }
}