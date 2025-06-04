import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:broker/feature/home/data/models/category_model.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:broker/feature/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  int buttonIndex = 0;
  final HomeRepo homeRepo;
  List<UnitModel> allUnits = [];
  String currentCategory = 'All';

  Map<String, List<UnitModel>> unitsByCategory = {'شاليه': [], 'شقه': []};
  List<CategoryModel> CATEGORIES = [
    CategoryModel(
        image: 'https://thepeakeg.com/wp-content/uploads/2024/10/6-1.png',
        type: 'Apartment'),
    CategoryModel(
        image: 'https://thepeakeg.com/wp-content/uploads/2024/10/6-1.png',
        type: 'Townhouse'),
    CategoryModel(
        image: 'https://thepeakeg.com/wp-content/uploads/2024/10/6-1.png',
        type: 'Twinhouse'),
    CategoryModel(
        image: 'https://thepeakeg.com/wp-content/uploads/2024/10/6-1.png',
        type: 'villa'),



  ];
//CategoryModel ALL = CategoryModel(image: 'https://thepeakeg.com/wp-content/uploads/2024/10/6-1.png', type: 'all');
//CategoryModel App=CategoryModel(image: 'https://thepeakeg.com/wp-content/uploads/2024/10/6-1.png', type: 'all');

  Future<void> getUnits() async {
    emit(FetchUnitsLoading());
    final result = await homeRepo.fetchUnits();
    log('Result fetched');
    result.fold(
          (failure) {
        log('Failure: ${failure.message}');
        emit(FetchUnitsFailure(failure.message));
      },
          (units) {
        allUnits = units; // تأكد أن allUnits موجودة في هذا السياق
        log('Units fetched: $units');
        emit(FetchUnitsSuccess(allUnits)); // إصدار الحالة مع البيانات
      },
    );}

  Future<void> getUnitsTypes(String type) async {
    emit(FetchUnitsLoading());
    final result = await homeRepo.fetchUnitsTypes(type);
    {
      result.fold(
        (failure) {
          emit(FetchUnitsFailure(failure.message));
        },
        (units) {
          log(units.toString());
          unitsByCategory[type] = units;
          emit(FetchUnitsSuccess(units));
        },
      );
    }
  }

  changePageState(int newIndex) {
    buttonIndex = newIndex;
    emit(ChangeCurrentPageRequest());
  }

  changeCurrentCategory(String newCategory) {
    currentCategory = newCategory;
    emit(ChangeCurrentCategory());
  }
}
