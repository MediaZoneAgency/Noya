import 'package:broker/core/network/dio_factory.dart';
import 'package:broker/feature/auth/data/repo/auth_repo.dart';
import 'package:broker/feature/auth/logic/auth_cubit.dart';
import 'package:broker/feature/booking/logic/cubit/booking_cubit.dart';
import 'package:broker/feature/chat/data/repo/chat_services.dart';
import 'package:broker/feature/chat/data/repo/websocket_chat.dart';
import 'package:broker/feature/home/data/repo/home_repo.dart';
import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/nav_bar/logic/nav_bar_cubit.dart';
import 'package:broker/feature/profie/data/repo/profile_repo.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/unitDetails/logic/details_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../feature/chat/logic/chat_cubit.dart';
import '../../feature/like/logic/fav_cubit.dart';
import '../../feature/search/data/repo/search_repo.dart';
import '../../feature/search/logic/search_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async
{
 Dio dio = DioFactory.getDio();
 Dio dio2=DioFactory.getDio2();
getIt.registerFactory<AuthService>(() => (AuthService(dio)));
getIt.registerFactory<AuthCubit>(() => (AuthCubit(getIt())));
 getIt.registerLazySingleton<NavBarCubit>(() => NavBarCubit());
 getIt.registerFactory<HomeRepo>(() => HomeRepo(dio));
 getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt()));
 getIt.registerLazySingleton<DetailsCubit>(() => DetailsCubit());
 getIt.registerFactory<ProfileRepo>(() => ProfileRepo(dio));
 getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));
 getIt.registerFactory<SearchRepo>(() => SearchRepo(dio));
 getIt.registerLazySingleton<SearchCubit>(() => SearchCubit(getIt()));
 
getIt.registerLazySingleton<WebSocketService>(() => WebSocketService());
 getIt.registerFactory<ChatService>(() => ChatService(dio2));
 //getIt.registerLazySingleton<ChatCubit>(() => ChatCubit(getIt()));
 getIt.registerLazySingleton<ChatCubit>(
() => ChatCubit(
 getIt(),
 getIt<WebSocketService>(),
),
);
 getIt.registerLazySingleton<FavCubit>(() => FavCubit());
 

 getIt.registerLazySingleton<BookingCubit>(() => BookingCubit(getIt()));
}