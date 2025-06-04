import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/core/theming/colors.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/profie/ui/widget/contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:io';

import '../../../../core/db/cached_app.dart';
import '../../../../core/helpers/cash_helper.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/sharedWidgets/app_text_button.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../widget/circle.dart';
import '../widget/guest.dart';
import '../widget/profile_loading_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getProfile();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
if (state is ProfileLoading) {
return const Skeletonizer(
enabled: true,
child: UiLoadingProfileScreen(),
);
}
if (ProfileCubit.get(context).profileUser != null) {
        return Scaffold(
          backgroundColor: ColorsManager.mainDarkBlack,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  CircleAvatr(user:ProfileCubit.get(context).profileUser!.name! ,),
                  SizedBox(height: 14),
                  ContactDetails(
                    title: ' Your Email',
                    content: ProfileCubit.get(context).profileUser!.email!,
                    img: 'assets/img/mail-01 (1).svg',
                  ),
                  SizedBox(height: 14),
                  ContactDetails(
                    title: 'Phone Number',
                    content:
                        ProfileCubit.get(context).profileUser!.phoneNumber!,
                    img: 'assets/img/Vector (4).svg',
                  ),
                  SizedBox(height: 14),
                  ContactDetails(
                    title: 'City',
                    content: ProfileCubit.get(context).profileUser!.role!,
                    img: '',
                  ),
                  SizedBox(height: 140),
                  AppTextButton(
                    buttonText: S.of(context).Logout,
                    textStyle: TextStyles.latoMedium17White,
                    verticalPadding: 3,
                    buttonHeight: 30,
                    onPressed: () {
                      CashHelper.clear();
                      CachedApp.clearCache();
                      DioFactory.removeTokenIntoHeaderAfterLogout();
                      NavBarCubit.get(context).changeIndex(0);
                      ProfileCubit.get(context).profileUser=null;
                      context.pushNamedAndRemoveUntil(Routes.signUpScreen,
                          predicate: (Route<dynamic> route) => false);
                    },
                  ),
                  Center(
                      child: Text(
                    'Delete Your Account',
                    style: TextStyles.latoBold12red,
                  )),
                ],
              ),
            )

        );}
        return GuestProfile();
      }
    );
  }
}
// BlocBuilder<ProfileCubit, ProfileState>(
// builder: (context, state) {
// if (state is ProfileLoading) {
// return const Skeletonizer(
// enabled: true,
// child: UiLoadingProfile(),
// );
// }
// if (ProfileCubit.get(context).profileUser != null) {
// return Padding(
// padding: EdgeInsets.symmetric(horizontal: 26.0.w),
// child: Row(
// children: [
// AppCachedNetworkImage(image:ProfileCubit.get(context).profileUser!.profilePicture, width: 54, height: 54, radius: 200,
//
// ),
// horizontalSpace(17),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// ProfileCubit.get(context).profileUser!.name!,
// style: TextStyles.poppinsRegular16contantGray,
// ),
// Text(
// ProfileCubit.get(context).profileUser!.email!,
// style: TextStyles.poppinsRegular16LightGray,
// ),
// ],
// )
// ],
// ),
// );
// }
// return GuestProfile();
// },
// ),