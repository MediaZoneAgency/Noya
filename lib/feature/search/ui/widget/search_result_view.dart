import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/home/ui/widgets/ui_loading_category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/sharedWidgets/unit_widget.dart';
import '../../logic/search_cubit.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
  builder: (context, state) {
   if (state is SearchLoading) {
      return const Skeletonizer(
        enabled: true,
        child:  UiLoadingUnitItem(),
      );
    }
    if (SearchCubit.get(context).searchResults.isNotEmpty) {
      return Column(
        children: [
          ...SearchCubit.get(context)
              .searchResults.map((e)=>UnitItem(e))

        ],
      );
    }
    return  SizedBox(height: 20,);

  },
);
  }
}
