import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/home/ui/widgets/ui_loading_category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/sharedWidgets/unit_widget.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
   if (state is FetchUnitsLoading) {
      return const Skeletonizer(
        enabled: true,
        child:  UiLoadingUnitItem(),
      );
    }
    if (HomeCubit.get(context).unitsByCategory.isNotEmpty) {
      return Column(
        children: [

          ...HomeCubit.get(context)
              .unitsByCategory[HomeCubit.get(context).
          currentCategory]!.map((e)=>UnitItem(e))

        ],
      );
    }
    return  SizedBox(height: 20,);

  },
);
  }
}
