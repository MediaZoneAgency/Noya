import 'package:broker/core/sharedWidgets/top_rated_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../feature/home/logic/home_cubit.dart';
import '../../feature/like/logic/fav_cubit.dart';
import '../../feature/profie/logic/profile_cubit.dart';
import '../theming/colors.dart';

class TopPropertyList extends StatelessWidget {
  const TopPropertyList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavCubit, FavState>(
  builder: (context, state) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          height: 320.h,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: HomeCubit.get(context).allUnits.length, // Set an appropriate itemCount), // Specify item count to prevent infinite items
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap
                    },
                    child:  TopPropertyItem(HomeCubit.get(context).allUnits[index], onTap: () {
                    if (ProfileCubit.get(context).profileUser != null){
                    if( FavCubit.get(context).favorite.contains(
                    HomeCubit.get(context).allUnits[index].id)
                    ){
                    FavCubit.get(context).removeFromWishList(
                    HomeCubit.get(context).allUnits[index]
                    );
                    }else{
                    FavCubit.get(context).addToWishList(model: HomeCubit.get(context).allUnits[index]);
                    }}else{
                    Fluttertoast.showToast(
                    msg: "You Don't have account",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: ColorsManager.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                    );
                    }},
                        isFavorite: FavCubit.get(context).favorite.contains(
                        HomeCubit.get(context).allUnits[index].id),
                    )

                  ),
                );
              },
            ),
          ),
        );
      },
    );
  },
);
  }
}
