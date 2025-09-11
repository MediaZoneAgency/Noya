// lib/feature/like/ui/screen/like_screen.dart

import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/screen/side_menu.dart'; // استيراد MenuScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart'; // استيراد ZoomDrawer
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theming/styles.dart';
import '../../../home/ui/widgets/ui_loading_category_view.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../../logic/fav_cubit.dart';
import '../widget/wishlist_list.dart';

// ==========================================================
// VVV      الخطوة الأولى: إضافة غلاف (Wrapper) للـ Drawer      VVV
// ==========================================================
class LikeScreenWithDrawer extends StatefulWidget {
  const LikeScreenWithDrawer({super.key});

  @override
  State<LikeScreenWithDrawer> createState() => _LikeScreenWithDrawerState();
}

class _LikeScreenWithDrawerState extends State<LikeScreenWithDrawer> {
 late final ZoomDrawerController  _drawerController ;
@override
  void initState() {
    super.initState();
    // 3. Initialize the controller here, only once
   _drawerController  = ZoomDrawerController();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
        // Use the same image you had in AiChatScreen
        image: DecorationImage(
          image: AssetImage('assets/img/image 2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ZoomDrawer(
        controller: _drawerController,
        slideWidth: MediaQuery.of(context).size.width * 0.85,
        angle: 0,
        borderRadius: 26.0,
        style: DrawerStyle.defaultStyle,
        //  showShadow: true,
        menuBackgroundColor: Colors.transparent,
        drawerShadowsBackgroundColor: Colors.grey[300]!,
        //mainScreenOverlayColor: Colors.transparent,
        mainScreen: ClipRRect(
          // 1. نستخدم ClipRRect لقص الحواف
          borderRadius:
              BorderRadius.circular(24.0), // يجب أن تكون نفس قيمة الـ ZoomDrawer
          child: Container(
            // 2. نستخدم Container لإضافة الإطار (Border)
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4), // لون الظل وقوته
                  spreadRadius: 2, // مدى انتشار الظل
                  blurRadius: 15, // درجة التمويه (Blur)
                  offset: const Offset(
                      -5, 0), // اتجاه الظل (X, Y) - هنا لليسار قليلاً
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2), // لون الإطار شفاف قليلاً
                width: 1.0, // سماكة الإطار
              ),
            ),
            // 3. بداخل الإطار نضع الشاشة الرئيسية
            child: LikeScreen(drawerController: _drawerController),
          ),
        ),
      
        menuScreen:
            SideMenu(controller: _drawerController), // Corrected SideMenu call
      ),
    );

    // ZoomDrawer(
    //   controller: _drawerController,
    //   style: DrawerStyle.defaultStyle,
    //   menuScreen:   SideMenu(controller: _drawerController),
    //   mainScreen: LikeScreen(drawerController: _drawerController), // تمرير الـ controller
    //   borderRadius: 40.0,
    //   showShadow: true,
    //   angle: -8.0,
    //   slideWidth: MediaQuery.of(context).size.width * 0.78,
    //   mainScreenTapClose: true,
    //   drawerShadowsBackgroundColor: Colors.black.withOpacity(0.3),
    // );
  }
}

// ==========================================================
// VVV الخطوة الثانية: تعديل شاشة المفضلة لاستقبال الـ Controller VVV
// ==========================================================
class LikeScreen extends StatefulWidget {
  final ZoomDrawerController drawerController;
  const LikeScreen({Key? key, required this.drawerController})
      : super(key: key);

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  // لم نعد بحاجة لـ _scaffoldKey
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (context.read<ProfileCubit>().profileUser != null) {
      context.read<FavCubit>().getWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // تم تبسيط الـ Scaffold
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/img/image 2.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                // AppBar المخصص الجديد
                _buildAppBar(),
                Expanded(
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (ProfileCubit.get(context).profileUser == null) {
                        return _buildLoginPrompt(context);
                      }
                      return BlocBuilder<FavCubit, FavState>(
                        builder: (context, state) {
                          if (state is GetWishListLoading) {
                            return const Skeletonizer(
                              enabled: true,
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    UiLoadingUnitItem(),
                                    UiLoadingUnitItem(),
                                    UiLoadingUnitItem(),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (FavCubit.get(context).wishList.isNotEmpty) {
                            return const WishlistList();
                          }
                          return _buildEmptyState(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء الـ AppBar المخصص
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
           onPressed: () {
    // Check if the controller's toggle function is not null before calling it
    if (widget.drawerController.toggle != null) {
      widget.drawerController.toggle!();
    }
  },
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          ),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final userImage = context.read<ProfileCubit>().profileUser?.image;
              return CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                backgroundImage: (userImage != null && userImage.isNotEmpty)
                    ? NetworkImage(userImage)
                    : null,
                child: (userImage == null || userImage.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/img/Animation - 1732019401672.json',
                height: 200.h),
            SizedBox(height: 24.h),
            Text("Your Wishlist is Empty", style: TextStyles.latoBold22White),
            SizedBox(height: 8.h),
            Text(
              "Add properties you like to your wishlist by tapping the heart icon.",
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => NavBarCubit.get(context).changeIndex(0),
              child: const Text("Explore Now"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/img/Animation - 1732019401672.json',
                height: 200.h),
            SizedBox(height: 24.h),
            Text("Login to See Your Likes", style: TextStyles.latoBold22White),
            SizedBox(height: 8.h),
            Text(
              "Log in to save and view your favorite properties across all your devices.",
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                // context.pushNamedAndRemoveUntil(
                //   Routes.signUpScreen
                //     predicate: (Route<dynamic> route) => false);
              },
              child: const Text("Login / Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
