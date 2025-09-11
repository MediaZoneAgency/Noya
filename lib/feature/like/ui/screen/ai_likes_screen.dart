// import 'package:broker/core/helpers/extensions.dart';
// import 'package:broker/feature/profie/logic/profile_cubit.dart';
// import 'package:broker/feature/screen/side_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../../../../core/routes/routes.dart';
// import '../../../../core/sharedWidgets/unit_list.dart';
// import '../../../../core/theming/colors.dart';
// import '../../../../core/theming/styles.dart';
// import '../../../../generated/l10n.dart';
// import '../../../home/logic/home_cubit.dart';
// import '../../../home/ui/widgets/ui_loading_category_view.dart';
// import '../../../nav_bar/logic/nav_bar_cubit.dart';
// import '../../logic/fav_cubit.dart';
// import '../widget/like_bar.dart';
// import '../widget/wishlist_list.dart';
//   import 'package:broker/core/helpers/extensions.dart';
// import 'package:broker/feature/profie/logic/profile_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../../../../core/routes/routes.dart';
// import '../../../../core/sharedWidgets/unit_list.dart';
// import '../../../../core/theming/colors.dart';
// import '../../../../core/theming/styles.dart';
// import '../../../../generated/l10n.dart';
// import '../../../home/logic/home_cubit.dart';
// import '../../../home/ui/widgets/ui_loading_category_view.dart';
// import '../../../nav_bar/logic/nav_bar_cubit.dart';
// import '../../logic/fav_cubit.dart';
// import '../widget/like_bar.dart';
// import '../widget/wishlist_list.dart';

// class LikeScreen2 extends StatefulWidget {
//   const LikeScreen2({Key? key}) : super(key: key);

//   @override
//   State<LikeScreen2> createState() => _LikeScreenState();
// }

// class _LikeScreenState extends State<LikeScreen2> {
//   // ✅ الخطوة 1: إضافة مفتاح للـ Scaffold للتحكم في الـ Drawer
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     // التحقق من تسجيل الدخول قبل جلب المفضلة
//     if (context.read<ProfileCubit>().profileUser != null) {
//       context.read<FavCubit>().getWishList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey, // ✅ ربط المفتاح بالـ Scaffold
//       drawer: const CustomDrawer(), // ✅ إضافة الـ Drawer هنا
//       backgroundColor: const Color(0xff1F1F1F),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ================== ✅ الخطوة 2: بناء الـ AppBar الجديد ==================
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // أيقونة القائمة على اليسار
//                   IconButton(
//                     onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//                     icon: const Icon(Icons.menu, color: Colors.white, size: 28),
//                   ),
//                   // صورة المستخدم على اليمين
//                   BlocBuilder<ProfileCubit, ProfileState>(
//                     builder: (context, state) {
//                       final userImage =
//                           context.read<ProfileCubit>().profileUser?.image;
//                       return CircleAvatar(
//                         radius: 22,
//                         backgroundColor: Colors.white24, // لون احتياطي
//                         backgroundImage: (userImage != null && userImage.isNotEmpty)
//                             ? NetworkImage(userImage)
//                             : null,
//                         child: (userImage == null || userImage.isEmpty)
//                             ? const Icon(Icons.person, color: Colors.white)
//                             : null,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // ======================================================================

//             // ✅ الخطوة 3: جعل المحتوى قابلاً للتمرير ويأخذ باقي الشاشة
//             Expanded(
//               child: BlocBuilder<ProfileCubit, ProfileState>(
//                 builder: (context, state) {
//                   // هذا الجزء يبقى كما هو ولكن داخل Expanded
//                   return BlocBuilder<FavCubit, FavState>(
//                     builder: (context, state) {
//                       if (ProfileCubit.get(context).profileUser != null) {
//                         if (state is GetWishListLoading) {
//                           return const Skeletonizer(
//                             enabled: true,
//                             child: SingleChildScrollView(
//                               physics: NeverScrollableScrollPhysics(),
//                               child: Column(
//                                 children: [
//                                   UiLoadingUnitItem(),
//                                   UiLoadingUnitItem(),
//                                   UiLoadingUnitItem(),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }
//                         if (FavCubit.get(context).wishList.isNotEmpty) {
//                           return const WishlistList(); // هذه يجب أن تكون ListView
//                         }
//                         return _buildEmptyState(context); // حالة المفضلة الفارغة
//                       } else {
//                         return _buildLoginPrompt(context); // حالة عدم تسجيل الدخول
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ويدجت مساعدة لعرض حالة "المفضلة فارغة"
//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Lottie.asset(
//               'assets/img/Animation - 1732019401672.json',
//               height: 200.h,
//             ),
//             SizedBox(height: 24.h),
//             Text("Your Wishlist is Empty", style: TextStyles.latoBold22White),
//             SizedBox(height: 8.h),
//             Text(
//               "Add properties you like to your wishlist.",
//               style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ويدجت مساعدة لحث المستخدم على تسجيل الدخول
//   Widget _buildLoginPrompt(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Lottie.asset(
//               'assets/img/Animation - 1732019401672.json',
//               height: 200.h,
//             ),
//             SizedBox(height: 24.h),
//             Text("Login to See Your Likes", style: TextStyles.latoBold22White),
//             SizedBox(height: 8.h),
//             Text(
//               "Log in to save and view your favorite properties.",
//               style: TextStyle(color: Colors.white70, fontSize: 16.sp),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24.h),
//             ElevatedButton(
//               onPressed: () {
//                 context.pushNamedAndRemoveUntil(Routes.signUpScreen,
//                     predicate: (Route<dynamic> route) => false);
//               },
//               child: const Text("Login / Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }