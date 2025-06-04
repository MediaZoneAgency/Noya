import 'package:broker/core/sharedWidgets/custom_slider.dart';
import 'package:broker/core/sharedWidgets/search_bar.dart';
import 'package:broker/core/sharedWidgets/top_property_container.dart';
import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/home/ui/widgets/home_bar.dart';
import 'package:broker/feature/home/ui/widgets/home_view.dart';
import 'package:broker/feature/home/ui/widgets/unit_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theming/styles.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../../../profie/logic/profile_cubit.dart';
import '../widget/search_result_view.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResultScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1F1F),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [

                CustomSearchBar(read: true,
                  ontap: () {
                    Navigator.pop(context, Routes.searchScreen);
                  },),
                SearchResultView()

              ],
            ),
          ),
        ],
      ),
    );
  }
}
