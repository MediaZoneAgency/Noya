import 'dart:ui' as ui;

import 'package:audio_service/audio_service.dart';
import 'package:broker/core/db/cash_helper.dart';
import 'package:broker/core/di/dependency_inj.dart';
import 'package:broker/core/loclization/localization_cubit.dart';
import 'package:broker/feature/chat/data/repo/voice_chat_background_task.dart';
import 'package:broker/feature/chat/logic/chat_cubit.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart';
import 'core/utils/approute.dart';
import 'core/utils/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'feature/auth/data/repo/auth_repo.dart';
import 'feature/auth/logic/auth_cubit.dart';
import 'generated/l10n.dart'; // Import the AuthRepository

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  await setupGetIt();
// @pragma('vm:entry-point')
// void backgroundEntryPoint() {
//   // ignore: deprecated_member_use
//   AudioServiceBackground.run(() => VoiceChatBackgroundTask());
// }//

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationCubit>(
          create: (_) => LocalizationCubit(),
        ),
           BlocProvider<ProfileCubit>.value(
          value: getIt<ProfileCubit>(),
        ),
         BlocProvider<ChatCubit>.value(
          value: getIt<ChatCubit>(),
        ),
        // ممكن تضيفي أي cubits تانية هنا كمان
      ],
      child: BrokerApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}

class BrokerApp extends StatelessWidget {
  final AppRouter appRouter;
  const BrokerApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
          builder: (context, localizationState) {
        Locale currentLocale;
        if (localizationState is LocalizationChanged) {
          currentLocale = localizationState.locale;
        } else {
          currentLocale = ui.window.locale;
        }
        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            locale: LocalizationCubit.get(context).locale,
            theme: ThemeData(),
            title: 'Noya',
            debugShowCheckedModeBanner: false,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: Routes.splashScreen,
            onGenerateRoute: appRouter.generateRoute,
          );
        });
      }),
    );
  }
  
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
