// lib/feature/screen/side_menu.dart

import 'dart:ui';


import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/core/network/dio_factory.dart';
import 'package:broker/core/sharedWidgets/network_image.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/src/drawer_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/db/cached_app.dart';
import '../../core/utils/routes.dart';
import '../../../../core/db/cash_helper.dart';
import '../../../../generated/l10n.dart';

//import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../generated/l10n.dart';

import '../../core/network/dio_factory.dart';
class SideMenu extends StatelessWidget {
  final ZoomDrawerController controller;
  const SideMenu({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // I'm restoring the previous structure which was correct.
    // The Container with decoration and Material are necessary for the UI.
    return Material( // Keep the Material widget to avoid ListTile errors
      color: Colors.transparent,
      child: SafeArea( // Keep SafeArea for screen notches
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // No changes needed for the user profile header
            _buildUserProfile(context),
            // const Divider(color: Colors.white24, height: 1),
    
            // THE FIX: Wrap ListDrawerItems in an Expanded widget
            Expanded(
              child: ListDrawerItems(controller: controller),

            ),
    
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                 child: LanguageSwitcher(),
               ),

          ],
        ),
      ),
    );
  }
}
 
 
  Widget _buildUserProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) return const UiLoadingProfile();
          final user = ProfileCubit.get(context).profileUser;
          return Row(
            children: [
              AppCachedNetworkImage(image: user?.image ?? "", height: 52.h, width: 45.w, radius: 26.r),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? "Guest", overflow: TextOverflow.ellipsis, style: GoogleFonts.lato(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(user?.email ?? "", overflow: TextOverflow.ellipsis, style: GoogleFonts.lato(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

// Widget _buildMenuItem(BuildContext context, String title, String svgPath, VoidCallback onTap) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
//       leading: SvgPicture.asset(svgPath , width: 24, height: 24, colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.srcIn)),
//       horizontalTitleGap: 16,
//       title: Text(title, style: GoogleFonts.lato(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
//       onTap: onTap,
//     );
//   }
// lib/feature/screen/side_menu.dart

// ... (keep all your existing imports)

class DrawerItem extends StatelessWidget {
  final String title;
  final String svgPath;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.svgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // This is the exact implementation from your _buildMenuItem function
    return ListTile(
      contentPadding: const EdgeInsets.symmetric( horizontal: 14.0),
      leading: SvgPicture.asset(
        svgPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.srcIn),
      ),
      horizontalTitleGap: 16,
      title: Text(
        title,
        style: GoogleFonts.lato(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    );
  }
}
  class UiLoadingProfile extends StatelessWidget {
  const UiLoadingProfile({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 12,
              color: Colors.grey.shade800,
            ),
            const SizedBox(height: 8),
            Container(
              width: 150,
              height: 10,
              color: Colors.grey.shade800,
            ),
          ],
        )
      ],
    );
  }
}
// lib/feature/screen/side_menu.dart

class ListDrawerItems extends StatelessWidget {
  final ZoomDrawerController controller;

  const ListDrawerItems({super.key, required this.controller});
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // يمكنك هنا إظهار رسالة خطأ للمستخدم إذا فشل فتح الرابط
      print('Could not launch $urlString');
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Could not open the link.')),
      // );
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView( // Using ListView is better than Column for potential scrolling
     // padding: EdgeInsets.zero,
      children: [
        DrawerItem(
          title: S.of(context).Home,
          svgPath: "assets/img/home.svg",
          onTap: () {
            controller.close!();
            // A short delay ensures the drawer is closing while navigating
            Future.delayed(const Duration(milliseconds: 250), () {
              context.pushNamed(Routes.AiChatScreen);
            });
          },
        ),
        DrawerItem(
          title: S.of(context).likes,
          svgPath: "assets/img/Group 1171274908 (1).svg",
          onTap: () {
            controller.close!();
            Future.delayed(const Duration(milliseconds: 250), () {
              context.pushNamed(Routes.wishListScreen);
            });
          },
        ),
        DrawerItem(
          title: S.of(context).bookings,
          svgPath: "assets/img/Group 1171274924.svg",
          onTap: () {
            controller.close!();
            Future.delayed(const Duration(milliseconds: 250), () {
              context.pushNamed(Routes.BookingScreen);
            });
          },
        ),
        DrawerItem(
          title: S.of(context).helpFaq,
          svgPath: "assets/img/Group 1171274909 (1).svg",
          onTap: () {
            controller.close!();
         _launchUrl('https://noyaai.com/privacy_policy');
          },
        ),
        DrawerItem(
          title: S.of(context).ContactUs,
          svgPath: "assets/img/Group 1171274910 (1).svg",
          onTap: () {
            controller.close!();
            // Add navigation later if needed
          },
        ),
        DrawerItem(
          title: S.of(context).Settings,
          svgPath: "assets/img/TOZ.svg",
          onTap: () {
            controller.close!();
            // Add navigation later if needed
          },
        ),
        DrawerItem(
          title: S.of(context).Logout,
          svgPath: "assets/img/circle-lock-01.svg",
          onTap: () {
            // No need to close the controller here, the dialog flow handles it.
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(S.of(dialogContext).Cansel),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close the dialog
                      CashHelper.clear();
                      DioFactory.removeTokenIntoHeaderAfterLogout();
                        CashHelper.clear();
                  CachedApp.clearCache();
                  DioFactory.removeTokenIntoHeaderAfterLogout();
              
                  ProfileCubit.get(context).profileUser=null;
                      Navigator.of(context).pushNamedAndRemoveUntil(
     Routes.signUpScreen
                 ,
  (Route<dynamic> route) => false, // This predicate removes all previous routes
);
                
                },
                      // Add your navigation logic to the login screen here
                
                    child: Text(S.of(context).Logout,
                        style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      

      ],
    );
  }
}
// Enum لتمثيل اللغات المتاحة
enum AppLanguage { english, arabic }

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  // متغير لتخزين اللغة المختارة حالياً
  AppLanguage _selectedLanguage = AppLanguage.english; // القيمة الافتراضية

  @override
  Widget build(BuildContext context) {
    // يمكنك هنا قراءة اللغة الحالية من Provider أو Bloc وتحديث _selectedLanguage
    // مثال: _selectedLanguage = context.watch<LocaleProvider>().language;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      height: 40.h, // ارتفاع مناسب
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // أيقونة الكرة الأرضية
          Icon(
            Icons.language,
            color: Colors.white.withOpacity(0.7),
            size: 24.sp,
          ),
          SizedBox(width: 16.w),

          // خيار اللغة الإنجليزية
          _buildLanguageOption(
            context,
            title: 'English',
            language: AppLanguage.english,
          ),

          // الفاصل العمودي
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              width: 1,
              height: 20.h, // ارتفاع الفاصل
              color: Colors.white.withOpacity(0.5),
            ),
          ),

          // خيار اللغة العربية
          _buildLanguageOption(
            context,
            title: 'العربية',
            language: AppLanguage.arabic,
          ),
        ],
      ),
    );
  }

  // ودجت مساعد لبناء كل خيار لغة
  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required AppLanguage language,
  }) {
    // تحديد ما إذا كان هذا الخيار هو المختار حالياً
    final bool isSelected = _selectedLanguage == language;

    return InkWell(
      onTap: () {
        // عند الضغط، قم بتحديث الحالة
        setState(() {
          _selectedLanguage = language;
        });
        
        // **مهم:** هنا تضع منطق تغيير اللغة الفعلي في تطبيقك
        // مثال: context.read<LocaleProvider>().setLocale(newLocale);
        print("Selected Language: $language");
      },
      // لإزالة تأثير الـ splash الزائد
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        title,
        style: GoogleFonts.inter( // استخدام الخط من التصميم
          fontSize: 16.sp,
          // ✅ تغيير اللون بناءً على الاختيار
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}