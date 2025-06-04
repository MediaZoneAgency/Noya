import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/error/error_model.dart';
import '../../home/data/models/unit_model.dart';
import '../data/repo/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.searchRepo) : super(SearchInitial());
  static SearchCubit get(context) => BlocProvider.of(context);
  SearchRepo searchRepo;
  List<UnitModel> searchResults = [];
  String currentCategoryId = "";
  double minPrice = 0;
  double maxPrice = 100000;
  String categoryName = "";

  final List<String> searches = [
    'white pull over',
    'T-shirt',
  ];
  Future<void> fetchSearchResults(String search,
double minPrice,
double maxPrice,

      String Type
      ) async {
    searchResults=[];
    emit(SearchLoading());
    var result = await searchRepo.getSearch(
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
        categoryName: Type,
        // room:room ,
        // bathrooms: bathrooms,
        // price: price ,
        // size: size
    );
    result.fold(
          (failure) {
        emit(SearchFailure( failure));
      },
          (response) {
        searchResults = response;
        emit(SearchSuccess());
      },
    );
  }
  void minPriceChange (double newMinPrice){
    minPrice=newMinPrice;
    emit(MinPriceChange());

  }
  void maxPriceChange (double newMaxPrice){
    maxPrice=newMaxPrice;
    emit(MaxPriceChange());

  }
}
