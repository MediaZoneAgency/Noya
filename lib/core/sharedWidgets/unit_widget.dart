import 'package:broker/core/sharedWidgets/network_image.dart';
import 'package:broker/core/sharedWidgets/property_card.dart';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../feature/unitDetails/ui/screen/unit_details_screen.dart';
import '../theming/colors.dart';

class UnitItem extends StatelessWidget {
  const UnitItem(this.unit, {super.key,  });
  final UnitModel unit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onDoubleTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnitDetailsScreen(
                unit:unit, // Replace 'someUnitModel' with the actual UnitModel object
              ),
            ),
          );
        },
        child: Container(
          width: 362.w,
          height: 495.h,
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(217, 217, 217, 0.2331),
      Color.fromRGBO(115, 115, 115, 0.1701),
    ],
  ),
          

            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

          Text(
         unit.type??"not valid type ",
            style:TextStyles.urbanistSemiBold18Light
          ),
  SizedBox(height: 12.h),
                 Text(
             unit.location??"not valid location ",
              style:TextStyles.urbanistMedium14Light,
            ),
                Container(
                  width: 360.w,
                  height: 220.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), ),
                     child:
                     AppCachedNetworkImage(
                       image:
                       unit.images?.first ??'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fwhite-texture&psig=AOvVaw2SJEXzMQXe3sTyiwVRMzQ_&ust=1734429114102000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCOjR8ouCrIoDFQAAAAAdAAAAABAE',
                       fit: BoxFit.cover,
                     ),
                    // DecorationImage(
                    //   image:
                    //   NetworkImage(unit.images?.first ?? ''),
                    //   fit: BoxFit.cover,
                    // ),

                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6,bottom: 6),
                  child: PropertyCard(location: unit.location??"not valid location ", type:unit.type??"not valid type ", price: unit.price??"not valid price",),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
