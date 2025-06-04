import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/sharedWidgets/unit_list.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../../../home/logic/home_cubit.dart';
import '../../../home/ui/widgets/ui_loading_category_view.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../../logic/fav_cubit.dart';
import '../widget/like_bar.dart';
import '../widget/wishlist_list.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {


  @override
  void initState() {
    super.initState();
    FavCubit.get(context).getWishList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1F1F),
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
  builder: (context, state) {
    return LikeBar(username: ProfileCubit.get(context).profileUser!.name!);
  },
),
                    SizedBox(height: 20,),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return BlocBuilder<FavCubit, FavState>(
                          builder: (context, state) {
                            if (ProfileCubit.get(context).profileUser != null) {
                              if (state is GetWishListLoading) {
                                return const Skeletonizer(
                                  enabled: true,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        UiLoadingUnitItem(),
                                        UiLoadingUnitItem(),
                                        UiLoadingUnitItem(),
                                        UiLoadingUnitItem(),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (FavCubit.get(context).wishList.isNotEmpty) {
                                return WishlistList();
                              }
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 42.h),
                                    Center(
                                      child: Lottie.asset(
                                          'assets/img/Animation - 1732019401672.json'),
                                    ),
                                    SizedBox(height: 48.h),
                                    GestureDetector(
                                      onTap: () {
                                        NavBarCubit.get(context).changeIndex(0);
                                      },
                                      child: Container(
                                        height: 40.h,
                                        width: 250.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: ColorsManager.mainDarkGray,
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return  Column(
                                children: [

                                  SizedBox(height: 42.h,),
                                  Center(
                                    child: Lottie.asset('assets/img/Animation - 1732019401672.json'),
                                  ),
                                  SizedBox(height: 48.h,),
                                  GestureDetector(
                                      onTap: (){
                                        context.pushNamedAndRemoveUntil(Routes.signUpScreen,
                                            predicate: (Route<dynamic> route) => false);

                                      },
                                      child:Container(
                                        height: 100.h,
                                        width: 327.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(color: ColorsManager.gray),
                                        ),
                                        )
                                  )
                                ],
                              );
                            }
                          },
                        );
                      },
                    )
                  ]

              ),
            ),
          ]
      ),

    );
  }
}
