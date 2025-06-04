import 'package:broker/core/sharedWidgets/top_property_container.dart';
import 'package:broker/feature/home/logic/home_cubit.dart';
import 'package:broker/feature/home/ui/widgets/category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state)
    {
      return
        HomeCubit
            .get(context)
            .currentCategory == "All"
            ?
        TopPropertyContainer()
            : CategoryView();
    });
  }
}
