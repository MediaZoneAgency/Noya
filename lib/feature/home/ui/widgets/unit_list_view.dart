import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/home/ui/widgets/unit_type_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/styles.dart';

class TypesListView extends StatelessWidget {
  const TypesListView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(

  builder: (context, state) {
    return SizedBox(
      height: 40.h,
      width: 600.w,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            onTap: (){
              HomeCubit.get(context).changeCurrentCategory("All");
            },
            child: Container(
              width: 56.w,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color:HomeCubit.get(context).currentCategory == "All" ?  Colors.white:Color(0xff353439) ,
              ),
              child: Center(
                child: Text(
                  'All',
                    style: TextStyles.inter9RegularWhite.copyWith(
                        color:HomeCubit.get(context).currentCategory == "All"?Color(0xff353439,): Colors.white
                    )
                ),
              ),

            ),
          ),
          ...HomeCubit.get(context).CATEGORIES.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                    onTap: () async {
                      HomeCubit.get(context).changeCurrentCategory(e.type);
                    await  HomeCubit.get(context).getUnitsTypes(e.type);
                    },
                    child: UnitTypeItem(model: e,backGroundColor:
                    HomeCubit.get(context).currentCategory == e.type ?  Colors.white:Color(0xff353439) ,
                        textColor: HomeCubit.get(context).currentCategory == e.type ?Color(0xff353439,)  : Colors.white),
              ))
          ),],
      ),
    );
  },
);
  }
}
