import 'package:broker/core/sharedWidgets/top_property_list.dart';
import 'package:broker/core/sharedWidgets/top_rated_item.dart';
import 'package:broker/core/sharedWidgets/unit_list.dart';
import 'package:broker/core/sharedWidgets/unit_widget.dart';
import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../feature/home/data/models/unit_model.dart';
import '../../feature/home/ui/widgets/ui_loading_category_view.dart';
import '../theming/colors.dart';
import '../theming/styles.dart';

class TopPropertyContainer extends StatelessWidget {
  const TopPropertyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          //   height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ColorsManager.mainDarkGray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Top Property',
                    style: TextStyles.latoBold18lightWhite,
                  ),
                ),

                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is FetchUnitsLoading) {
                    return const Skeletonizer(
                    enabled: true,
                    child:  UiLoadingUnitItem(),
                    );
                    }
                    if (HomeCubit.get(context).allUnits.isNotEmpty) {
                    return   const TopPropertyList();
                    }
                    return  SizedBox(height: 20,);

                    },





                ),

                UnitList()
              ]
          ),
        );
      },
    );
  }
}
