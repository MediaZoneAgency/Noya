
import 'package:broker/feature/unitDetails/ui/widget/ad_container.dart';
import 'package:broker/feature/unitDetails/ui/widget/details_bar.dart';
import 'package:broker/feature/unitDetails/ui/widget/features_container.dart';
import 'package:broker/feature/unitDetails/ui/widget/location_container.dart';
import 'package:flutter/material.dart';

import '../../../home/data/models/unit_model.dart';
import '../widget/description_container.dart';
import '../widget/image_carousel.dart';
class UnitDetailsScreen extends StatelessWidget {
  const UnitDetailsScreen({super.key, required this.unit});
  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1F1F),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                DetailsBar(
                  username: "sarah",
                  location: unit.location ?? "not valid location",
                  type: unit.type ?? "not valid type",
                  price: unit.price ?? "not valid price",
                ),
                ImageCarousel(imgList: unit.images ?? [],),
                const SizedBox(height: 20),
              DetailsContainer(bedroom: unit.rooms ?? 0, bathroom: unit.bathrooms ?? 0, space:unit.size ?? 0, description:unit.description ?? "didnt have description",),
                const SizedBox(height: 20),
                FeatureContainer(
                  feature1: unit.listOfDescription?.isNotEmpty == true ? unit.listOfDescription![0] : "No feature available",
                  feature2: unit.listOfDescription?.length != null && unit.listOfDescription!.length > 1
                      ? unit.listOfDescription![1]
                      : "No feature available",
                  feature3: unit.listOfDescription?.length != null && unit.listOfDescription!.length > 2
                      ? unit.listOfDescription![2]
                      : "No feature available",
                  feature4: unit.listOfDescription?.length != null && unit.listOfDescription!.length > 3
                      ? unit.listOfDescription![3]
                      : "No feature available",
                ),
                const SizedBox(height: 20),
                LocationContainer(),
                const SizedBox(height: 20),
                AdContainer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
