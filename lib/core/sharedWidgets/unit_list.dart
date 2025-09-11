import 'package:broker/core/sharedWidgets/unit_widget.dart'; // تأكد من صحة هذا المسار
import 'package:broker/core/theming/colors.dart';
import 'package:broker/feature/like/logic/fav_cubit.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart'; // ✅ استيراد ProfileCubit الصحيح
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../feature/home/logic/home_cubit.dart';

class UnitList extends StatelessWidget {
  const UnitList({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدم BlocBuilder ليشمل FavCubit أيضاً لضمان التحديث الفوري
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<FavCubit, FavState>(
          builder: (context, favState) {
            final homeCubit = HomeCubit.get(context);
            final favCubit = FavCubit.get(context);
            final profileCubit = ProfileCubit.get(context); // للوصول لبيانات المستخدم

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: homeCubit.allUnits.map((unit) { // ✅ استخدام 'unit' بدلاً من 'e' لزيادة الوضوح
                  
                  // ✅ الحل: استخدم 'unit' مباشرةً للوصول إلى الـ id
                  final bool isFavorite = favCubit.favorite.contains(unit.id);

                  return UnitItem(
                    unit,
                    isFavorite: isFavorite,
                    onFavoriteTap: () {
                      if (profileCubit.profileUser != null) {
                        // ✅ الحل: استخدم 'unit' هنا أيضاً
                        if (isFavorite) {
                          favCubit.removeFromWishList(unit);
                        } else {
                          favCubit.addToWishList(model: unit);
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "You Don't have an account",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: ColorsManager.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                  );
                }).toList(), // لا تنسى toList() بعد .map()
              ),
            );
          },
        );
      },
    );
  }
}