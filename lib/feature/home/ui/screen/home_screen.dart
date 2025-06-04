import 'package:broker/core/sharedWidgets/custom_slider.dart';
import 'package:broker/core/sharedWidgets/search_bar.dart';
import 'package:broker/core/sharedWidgets/top_property_container.dart';
import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/home/ui/widgets/home_bar.dart';
import 'package:broker/feature/home/ui/widgets/home_view.dart';
import 'package:broker/feature/home/ui/widgets/unit_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/styles.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../../../profie/logic/profile_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).getUnits();
    ProfileCubit.get(context).getProfile();
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
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return HomeBar(
                      username: ProfileCubit.get(context).profileUser!.name!,
                    );
                  },
                ),
                TypesListView(),
                CustomSearchBar(read: true,
                  ontap: () {
                    NavBarCubit.get(context).changeIndex(1);
                  },),
                Padding(
                  padding: const EdgeInsets.only(left: 20,),
                  child: Text(
                      'Price Range',
                      style: TextStyles.inter13SemiBoldLightGray
                  ),
                ),
                PriceRangeSlider(),
                HomeView()

              ],
            ),
          ),
        ],
      ),
    );
  }
}
