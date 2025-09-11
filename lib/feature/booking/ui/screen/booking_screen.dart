// lib/feature/bookings/ui/screen/bookings_screen.dart

import 'package:broker/feature/booking/logic/cubit/booking_cubit.dart';
import 'package:broker/feature/booking/ui/widgets/booking_widget.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/screen/side_menu.dart'; // استيراد MenuScreen
import 'package:broker/feature/unitDetails/ui/screen/unit_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart'; // استيراد ZoomDrawer
import 'package:google_fonts/google_fonts.dart';

// ==========================================================
// VVV      الخطوة الأولى: إضافة غلاف (Wrapper) للـ Drawer      VVV
// ==========================================================
class BookingsScreenWithDrawer extends StatefulWidget {
  const BookingsScreenWithDrawer({super.key});

  @override
  State<BookingsScreenWithDrawer> createState() => _BookingsScreenWithDrawerState();
}

class _BookingsScreenWithDrawerState extends State<BookingsScreenWithDrawer> {
  //final _drawerController = ZoomDrawerController();
 late final ZoomDrawerController  _drawerController ;
@override
  void initState() {
    super.initState();
    // 3. Initialize the controller here, only once
   _drawerController  = ZoomDrawerController();
  }
  
  @override
  Widget build(BuildContext context) {

    return
  
       Container(
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
            child: BookingsScreen(drawerController: _drawerController),
          ),
        ),
      
        menuScreen:
            SideMenu(controller: _drawerController), // Corrected SideMenu call
      ),
    );

    
    
  }
}


// ==========================================================
// VVV الخطوة الثانية: تعديل شاشة الحجوزات لاستقبال الـ Controller VVV
// ==========================================================
class BookingsScreen extends StatefulWidget {
  final ZoomDrawerController drawerController;
  const BookingsScreen({Key? key, required this.drawerController}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // لم نعد بحاجة لـ _scaffoldKey
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getUserBookingsAndDetails();
  }

  @override
  Widget build(BuildContext context) {
    // تم تبسيط الـ Scaffold
    return Scaffold(
      backgroundColor: Colors.transparent, // مهم لظهور الخلفية
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
                  child: BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      if (state is GetUserBookingsLoading) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }
                      if (state is GetUserBookingsError) {
                        return Center(child: Text(state.error, style: const TextStyle(color: Colors.white)));
                      }
                      if (state is GetUserBookingsDetailsSuccess) {
                        if (state.units.isEmpty) {
                          return const Center(child: Text("You have no appointments.", style: TextStyle(color: Colors.white, fontSize: 18)));
                        }
                        return _buildAppointmentsList(state.units);
                      }
                      // For Initial state or any other unhandled state
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
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
          Text(
            "Appointments",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              context.read<ProfileCubit>().profileUser?.image ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<UnitModel> units) {
    final rawBookings = context.read<BookingCubit>().rawBookings;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        final booking = rawBookings.firstWhere(
          (b) => b.propertyId == unit.id,
          orElse: () => throw Exception('Booking not found for unit ${unit.id}'), // Added for safety
        );
        
        return AppointmentCard(
          unit: unit,
          booking: booking,
          onViewDetails: () {
              showUnitDetailsDialog(context, unit);
            print("View details for ${unit.id}");
          },
          onCancel: () {
            print("Cancel booking for ${booking.id}");
          },
        );
      },
    );
  }
}
// file: lib/core/helpers/navigation_helper.dart (مثال)



// دالة مساعدة لإظهار شاشة تفاصيل الوحدة كـ Dialog
void showUnitDetailsDialog(BuildContext context, UnitModel unit) {
  Navigator.of(context).push(
    PageRouteBuilder(
      // جعل الصفحة شفافة
      opaque: false, 
      // جعل الخلفية شفافة
      pageBuilder: (context, animation, secondaryAnimation) {
        return UnitDetailsScreen(unit: unit);
      },
      // إضافة تأثير التلاشي (Fade) عند الظهور والاختفاء
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}