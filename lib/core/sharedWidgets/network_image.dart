import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:skeletonizer/skeletonizer.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    this.image,
    this.width,
    this.height,
    this.radius,
    this.loadingWidget,
    this.errorWidget,
    this.fit,
  });
  final String? image;
  final double? width;
  final double? height;
  final double? radius;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Container(
     clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 22),
      ),
      child: image != null
          ? CachedNetworkImage(
              width: width ?? 234.w,
              height: height ?? 145.h,
              fit: fit ?? BoxFit.cover,
              imageUrl: image ?? ' ',
              placeholder: (context, url) => Center(
                  child: Skeletonizer(
                    enabled: true, 
                    child: loadingWidget ?? Image.asset(
                                 "assets/img/download.jpg",
                                   width: width ?? 234.w,
                                  height: height ?? 145.h,
                                  fit: BoxFit.fill,
                                ),
                  )),
              errorWidget: (context, url, error) =>
                  errorWidget ??  Image.asset(
             "assets/img/download.jpg",
               width: width ?? 234.w,
              height: height ?? 145.h,
              fit: BoxFit.fill,
            ),
            )
          : Image.asset(
            "assets/img/download.jpg",
               width: width ?? 234.w,
              height: height ?? 145.h,
              fit: BoxFit.fill,
            ),
    );
  }
}
