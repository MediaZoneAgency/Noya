import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg package

import '../../../core/theming/colors.dart';
import '../logic/nav_bar_cubit.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key});

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xff1a1a1a).withOpacity(.5),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: NavBarCubit.get(context).screens[NavBarCubit.get(context).selectedIndex],
          bottomNavigationBar: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: BottomNavigationBar(
                iconSize: 25,
                backgroundColor: const Color(0xff282828).withOpacity(0.3), // Adjust opacity
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: ColorsManager.darkGray,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                currentIndex: NavBarCubit.get(context).selectedIndex,
                onTap: (index) {
                  NavBarCubit.get(context).changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/img/icon.svg',
                      color: NavBarCubit.get(context).selectedIndex == 0
                          ? Colors.white
                          : ColorsManager.darkGray,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/img/icon (3).svg',
                      color: NavBarCubit.get(context).selectedIndex == 1
                          ? Colors.white
                          : ColorsManager.darkGray,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/img/Chat.svg',
                      color: NavBarCubit.get(context).selectedIndex == 2
                          ? Colors.white
                          : ColorsManager.darkGray,
                    ),
                    label: 'Chat',
                  ),

                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/img/Vector (3).svg',
                      color: NavBarCubit.get(context).selectedIndex == 3
                          ? Colors.white
                          : ColorsManager.darkGray,
                    ),
                    label: 'Likes',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/img/Group.svg',
                      color: NavBarCubit.get(context).selectedIndex == 3
                          ? Colors.white
                          : ColorsManager.darkGray,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
