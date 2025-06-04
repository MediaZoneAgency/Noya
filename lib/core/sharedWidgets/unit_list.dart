import 'package:broker/core/sharedWidgets/top_rated_item.dart';
import 'package:broker/core/sharedWidgets/unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../feature/home/logic/home_cubit.dart';

class UnitList extends StatelessWidget {
  const UnitList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

             ...HomeCubit.get(context).allUnits.map((e)=> UnitItem(e))
            ],
          )

          // ListView.builder(
          //   physics: NeverScrollableScrollPhysics(),
          //   scrollDirection: Axis.vertical,
          //   itemCount: HomeCubit.get(context).units.length, // Set an appropriate itemCount), // Specify item count to prevent infinite items
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 6),
          //       child: GestureDetector(
          //         onTap: () {
          //           // Handle tap
          //         },
          //         child:  UnitItem(HomeCubit.get(context).units[index]),
          //       ),
          //     );
          //   },
          // ),
        );
      },
    );
  }
}
