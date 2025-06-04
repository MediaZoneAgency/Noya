import 'package:broker/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/sharedWidgets/custom_slider.dart';
import '../../../../core/sharedWidgets/search_bar.dart';
import '../../../../core/sharedWidgets/stay_go_switch.dart';
import '../../../../core/theming/styles.dart';
import '../../logic/search_cubit.dart';
import '../widget/category_filter_item.dart';
import '../widget/filter_section.dart';
import '../widget/location_bar.dart';
import '../widget/minmax_bar.dart';
import '../widget/option_selector.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xff1F1F1F),
      body: SafeArea(
        child: CustomScrollView(
         slivers:[
           SliverToBoxAdapter(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start ,
               children: [
                 SizedBox(height: 20,),
            CustomSearchBar(
              controller: _searchController ,
              onSubmit: (value) {
                SearchCubit.get(context).fetchSearchResults(
                    _searchController.text,
SearchCubit.get(context).minPrice,
                  SearchCubit.get(context).maxPrice,
                  _searchController.text,

                );
                context.pushNamed(Routes.resultScreen);
              },
            ),
                 Padding(
                   padding: const EdgeInsets.all(13.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start ,
                     children: [
                       Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: Text(
                               'Property Filter',
                               style: TextStyles.inter20SemiBoldGray,
                             ),
                           ),
                           Spacer(),
                           Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: Text(
                               'Reset all',
                               style: TextStyles.inter13MediumBlue ,
                             ),
                           )
                         ],
                       ),
                       SizedBox(height: 32.h,),
                       Text('Location',
                       style: TextStyles.inter13SemiBoldWhite,),
                       SizedBox(height: 24,),
                       CustomLocationBar(),
                       SizedBox(height: 31.3.h,),
                       Text('Rental Period',
                         style: TextStyles.inter13SemiBoldWhite,),
                       StayGoSwitch(),

                       Text('Rental Period',
                         style: TextStyles.inter13SemiBoldWhite,),
                       StayGoSwitch(),
                       Text('Price Range',
                         style: TextStyles.inter13SemiBoldWhite,),
                       SizedBox(height: 24,),
                       CustomMinMaxBar(),
                       SizedBox(height: 31,),
                       PriceRangeSlider(),
                       // Text('Bathrooms',
                       //   style: TextStyles.inter13SemiBoldWhite,),
                       const SizedBox(height: 24,),
             const FilterSection(
               title: "Bathrooms",
               child: OptionSelector(
                 options: ["Any", "0.0", "1.0", "1.5", "2.0", "2.5", "3+"],
               ),),
                       Text('Bedrooms',
                         style: TextStyles.inter13SemiBoldWhite,),
                       const SizedBox(height: 24,),
                       Row(
                         children: [

                           CategoryFilterItem( onTap: () {  }, isSelected: false, text: '0',),
                           SizedBox(width:15.52 ),
                           CategoryFilterItem( onTap: () {  }, isSelected: true, text: '1',),
                           SizedBox(width:15.52 ),
                           CategoryFilterItem( onTap: () {  }, isSelected: false, text: '2',),
                           SizedBox(width:15.52 ),
                           CategoryFilterItem( onTap: () {  }, isSelected: false, text: '3',),
                           SizedBox(width:15.52 ),
                           CategoryFilterItem( onTap: () { }, isSelected: false, text: '4',),
                           SizedBox(width:15.52 ),
                         ],
                       ),



                     ],
                   ),
                 )

               ]

             ),
           )
         ]

        ),
      ),

    );
  }
}
