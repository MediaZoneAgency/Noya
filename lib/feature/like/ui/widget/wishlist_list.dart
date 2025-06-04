import 'package:broker/core/sharedWidgets/top_rated_item.dart';
import 'package:broker/core/sharedWidgets/unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/fav_cubit.dart';
import 'Like_widget.dart';

class WishlistList extends StatelessWidget {
  const WishlistList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavCubit, FavState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

             ... FavCubit.get(context).wishList.map((e)=> LikeItem(onremove:(){ FavCubit.get(context).removeFromWishList(
                 e)!;} ,e))
            ],
          )

        );
      },
    );
  }
}
