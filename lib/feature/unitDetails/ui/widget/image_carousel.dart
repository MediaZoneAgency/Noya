import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theming/colors.dart';
import '../../logic/details_cubit.dart';

class ImageCarousel extends StatelessWidget {
  final List<dynamic> imgList;

  const ImageCarousel({Key? key, required this.imgList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return BlocProvider(
      create: (_) => DetailsCubit(),
      child: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          int currentIndex = context.read<DetailsCubit>().currentIndex;

          return Container(
            width: 350.w,
            height: 450.h,
            decoration: BoxDecoration(
              color: ColorsManager.mainThemeColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorsManager.mediumDarkGray),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:20),
              child: Column(
                children: [
                  // Main carousel
                  SizedBox(
                    width: 320.w,
                    height: 250,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: imgList.length,
                      onPageChanged: (index) {
                        context.read<DetailsCubit>().changeIndex(index);
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imgList[index],
                            fit: BoxFit.cover,
                            width: 1000,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Thumbnails
                  Container(
                    height: 60.h,
                    width: 318, // Allow it to use all available width
                    decoration: BoxDecoration(
                      color: ColorsManager.daGray,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: ColorsManager.unitcolor),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Make Row scrollable
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: imgList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                entry.key,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              context
                                  .read<DetailsCubit>()
                                  .changeIndex(entry.key);
                            },
                            child: Container(
                              width: 67.0,
                              height: 41.0,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: currentIndex == entry.key
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  entry.value,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Navigation arrows
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60.h,
                      width: double.infinity, // Adjust to available width
                      decoration: BoxDecoration(
                        color: ColorsManager.daGray,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: ColorsManager.unitcolor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/img/Button (1).svg',
                            ),
                            onPressed: () {
                              if (currentIndex > 0) {
                                context.read<DetailsCubit>().previousPage();
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/img/Button.svg',
                            ),
                            onPressed: () {
                              if (currentIndex < imgList.length - 1) {
                                context.read<DetailsCubit>().nextPage();
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
