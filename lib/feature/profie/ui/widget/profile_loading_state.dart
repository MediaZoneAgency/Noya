import 'package:broker/core/helpers/extensions.dart';
import 'package:broker/core/theming/colors.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:broker/feature/profie/ui/widget/contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:io';

import '../../../../core/db/cached_app.dart';
import '../../../../core/helpers/cash_helper.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/sharedWidgets/app_text_button.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../../../nav_bar/logic/nav_bar_cubit.dart';
import '../widget/circle.dart';

class UiLoadingProfileScreen extends StatelessWidget {
  const UiLoadingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          backgroundColor: ColorsManager.mainDarkBlack,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child:

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                CircleAvatr(user:"sncjksd mmmk" ,),
                SizedBox(height: 14),
                ContactDetails(
                  title: ' Your Email',
                  content:"mdkdsksdmdsknsdsmsdmnkjsa",
                  img: 'assets/img/mail-01 (1).svg',
                ),
                SizedBox(height: 14),
                ContactDetails(
                  title: 'Phone Number',
                  content:
                 "01093080829",
                  img: 'assets/img/Vector (4).svg',
                ),
                SizedBox(height: 14),
                ContactDetails(
                  title: 'City',
                  content:"mflkrmrf",
                  img: '',
                ),
                SizedBox(height: 140),

              ],
            )
          ),
        );


  }
}
