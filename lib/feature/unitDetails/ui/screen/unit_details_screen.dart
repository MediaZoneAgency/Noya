import 'dart:ui';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/map/ui/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/data/models/unit_model.dart';
import '../widget/ad_container.dart';
import '../widget/details_bar.dart';
import '../widget/features_container.dart';
import '../widget/location_container.dart';
import '../widget/description_container.dart';
import '../widget/image_carousel.dart';

class UnitDetailsScreen extends StatelessWidget {
  const UnitDetailsScreen({super.key, required this.unit});
  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            unit.type ?? "not valid type",
                            style: TextStyles.urbanistSemiBold18Light,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            unit.type ?? "not valid location",
                            style: TextStyles.urbanistMedium14Light,
                          ),
                          ImageCarousel(imgList: unit.images ?? []),
                          const SizedBox(height: 20),
                          DetailsContainer(
                            bedroom: unit.rooms ?? 0,
                            bathroom: unit.bathrooms ?? 0,
                            space: unit.size ?? 0,
                            description:
                                unit.description ?? "didn't have description", price: unit.price?? "0" ,
                          ),
                          const SizedBox(height: 20),
                          // FeatureContainer(
                          //   feature1: unit.listOfDescription?.isNotEmpty == true
                          //       ? unit.listOfDescription![0]
                          //       : "No feature available",
                          //   feature2: unit.listOfDescription != null &&
                          //           unit.listOfDescription!.length > 1
                          //       ? unit.listOfDescription![1]
                          //       : "No feature available",
                          //   feature3: unit.listOfDescription != null &&
                          //           unit.listOfDescription!.length > 2
                          //       ? unit.listOfDescription![2]
                          //       : "No feature available",
                          //   feature4: unit.listOfDescription != null &&
                          //           unit.listOfDescription!.length > 3
                          //       ? unit.listOfDescription![3]
                          //       : "No feature available",
                          // ),
                          const SizedBox(height: 36),
                          if (unit.location != null) ...[
  const SizedBox(height: 20),
  ChatLocationPreviewMap(locationLink: unit.location!),
],
const SizedBox(height: 36),

                           // مساحة أسفل
                        ],
                      ),
                    ),

                    // زر الإغلاق
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
