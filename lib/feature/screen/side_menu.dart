import 'dart:ui';

import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/core/loclization/localization_cubit.dart';
import 'package:broker/core/routes/routes.dart';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/db/cached_app.dart';
import '../../../../core/db/cash_helper.dart';
import '../../../../core/helpers/spacing.dart';

import '../../../../generated/l10n.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
//String? token= await CashHelper.getStringScoured(key: Keys.token);
    ProfileCubit.get(context).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
          borderRadius:
              LocalizationCubit.get(context).locale.languageCode == 'en'
                  ? BorderRadius.only(bottomLeft: Radius.circular(117.r))
                  : BorderRadius.only(bottomLeft: Radius.circular(117.r))),
      //  surfaceTintColor: Colors.white,
      width: 238.w,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return DrawerHeader(
                    name: ProfileCubit.get(context).profileUser!.name!,
                  );
                },
              ),
              //verticalSpace(30),
              // buildListTile(context, S.of(context).Home, ImagesManager.sideHome, () {
              //   context.pop();
              // }),
              // buildListTile(context, S.of(context).Requests, ImagesManager.sideRequest,
              //     () {
              //   context.pop();

              //   NavBarCubit.get(context).changeIndex(1);
              //   NavBarCubit.get(context).pageController.jumpToPage(1);
              // }),
              // buildListTile(context, S.of(context).chat, ImagesManager.sideChat, () {
              //   context.pop();
              //   context.pushNamed(Routes.chatScreen);
              // }),
              // buildListTile(context, S.of(context).Settings, ImagesManager.sideSetting,
              //     () {
              //       //context.pop();
              //   context.pushNamed(Routes.setting);
              // }),
              // buildListTile(
              //     context, S.of(context).Bookmarks, ImagesManager.sideBookmark, () {}),
              buildListTile(context,S.of(context).Logout, "assets/img/logout 1.svg",
                  () async {
              //  ProfileCubit.get(context).signOut();
                await CashHelper.clear();
                CachedApp.clearCache();
                context.pushNamedAndRemoveUntil(Routes.loginScreen,
                    predicate: (Route<dynamic> route) {
                  return false;
                });
               }),
           
              // buildListTile(context, S.of(context).Settings, ImagesManager.sideSetting,
              //     () {
              //       //context.pop();
              //   context.pushNamed(Routes.setting);
              // }),
           
            ],
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(
      BuildContext context, String title, String icon, Function() onTap) {
    return ListTile(
      title: GestureDetector(
        onTap: onTap,
        child: Row(children: [
          SvgPicture.asset(
            //color: Colors.black.withOpacity(0.46),
            icon,
            fit: BoxFit.scaleDown,
          ),
          horizontalSpace(24),
          Text(
            title,
            style: TextStyles.inter23MediumBlack.copyWith(fontSize: 19.sp),
          )
        ]),
      ),
      onTap: () {},
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 10.w, top: 20.h, bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage('assets/img/person.png' ),
            backgroundColor: Colors.white,
            child: SizedBox(),
            radius: 34.5.r,
          ),
          verticalSpace(15),
          Text(
            name,
            style: TextStyles.inter17BoldBlack,
          ),
          // GestureDetector(onTap:(){
          // //  context.pushNamed(Routes.profile);
          //   },
          //   child: Text(S.of(context).viewProfile,
          //   style: TextStyles.inter17RegularGray,))
          // AppTextButton(
          //
          //   verticalPadding: 30,
          //     buttonHeight: 42.h,
          //     buttonText: S.of(.
          // 
          // context).viewProfile,
          //     textStyle: TextStyles.inter17RegularGray,
          //     onPressed: () {
          //       context.pushNamed(Routes.profile);
          //     },
          //     //buttonWidth: 220.w,
          //     horizontalPadding: 0),
        ],
      ),
    );
  }
}
