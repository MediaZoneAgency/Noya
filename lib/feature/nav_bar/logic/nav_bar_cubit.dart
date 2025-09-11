import 'package:bloc/bloc.dart';
import 'package:broker/feature/chat/ui/screen/ai_chat_screen.dart';
import 'package:broker/feature/home/ui/screen/home_screen.dart';
import 'package:broker/feature/like/ui/screen/like_screen.dart';
import 'package:broker/feature/profie/data/repo/profile_repo.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/profie/ui/screen/profile_screen.dart';
import 'package:broker/feature/search/ui/screen/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/di/dependency_inj.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../chat/logic/chat_cubit.dart';
import '../../home/logic/home_cubit.dart';
import '../../like/logic/fav_cubit.dart';
import '../../search/logic/search_cubit.dart';


part 'nav_bar_state.dart';

// class NavBarCubit extends Cubit<NavBarState> {
//   final AuthCubit authCubit;
//
//   NavBarCubit(this.authCubit) : super(NavBarInitial());
// }
class NavBarCubit extends Cubit<NavBarState> {

  NavBarCubit() : super(NavBarInitial());

  static NavBarCubit get(context) => BlocProvider.of(context);
  int selectedIndex = 0;
  final screens = [
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(
          value: getIt<HomeCubit>(),
        ),

        BlocProvider<ProfileCubit>.value(
          value: getIt<ProfileCubit>(),
        ),
        BlocProvider<FavCubit>.value(
          value: getIt<FavCubit>(),
        ),
      ],
      child: const HomeScreen(),
    ),

    /// Notifications page
    BlocProvider<SearchCubit>.value(
      value: getIt<SearchCubit>(),
      child: SearchScreen(),
    ),
  //  BlocProvider<ChatCubit>.value(value: getIt<ChatCubit>(),child:AiChatScreen() ,),
      // MultiBlocProvider(
      //     providers: [
      //       BlocProvider<HomeCubit>.value(
      //         value: getIt<HomeCubit>(),
      //       ),

      //       BlocProvider<ProfileCubit>.value(
      //         value: getIt<ProfileCubit>(),
      //       ),
            
      //       BlocProvider<FavCubit>.value(
      //         value: getIt<FavCubit>(),
      //       ),
      //     ],
      //  //   child: const LikeScreen(),
      //   ),



    BlocProvider<ProfileCubit>.value(value: getIt<ProfileCubit>(),child:ProfileScreen() ,)

  ];

  changeIndex(int newIndex) {
    if (isClosed) return; // Prevent emitting if closed
    selectedIndex = newIndex;
    emit(ChangeIndex());
  }
}
