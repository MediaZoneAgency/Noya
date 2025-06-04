import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/db/cached_app.dart';
import '../../../core/error/error_model.dart';
import '../../home/data/models/unit_model.dart';

part 'fav_state.dart';

class FavCubit extends Cubit<FavState> {
  FavCubit() : super(FavInitial());


  static FavCubit get(context) => BlocProvider.of(context);

  List<int> favorite = [];
  List<UnitModel> wishList = [];

  // Add to local favorites
  Future<void> addToWishList({required UnitModel model}) async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      wishList.add(model);  // Add to wishlist
      favorite.add(model.id!);  // Add to favorites
      emit(AddToWishListLoading());

      // Persist the updated wishlist
       CachedApp.saveData(wishList, CachedDataType.wishlist.name);

      emit(AddToWishListSuccess());
    } else {
      emit(AddToWishListFailure(
          ApiErrorModel(message: 'No internet connection')));
    }
  }

  // Get local wishlist and favorites
  Future<void> getWishList() async {
    emit(GetWishListLoading());

    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        wishList = CachedApp.getCachedData(CachedDataType.wishlist.name);

        favorite = wishList.map((item) => item.id!).toList();

        emit(GetWishListSuccess());
      } catch (e) {
        emit(GetWishListLoading());
        emit(GetWishListFailure(ApiErrorModel(message: 'Failed to load data')));
      }
    } else {
      emit(GetWishListFailure(
          ApiErrorModel(message: 'No internet connection')));
    }
  }

  // Remove from local favorites
  Future<void> removeFromWishList(UnitModel model) async {
    emit(RemoveFromWishListLoading());

    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      wishList.removeWhere((element) => element.id == model.id);
      favorite.removeWhere((element) => element == model.id);

      // Persist the updated wishlist
      CachedApp.saveData(wishList, CachedDataType.wishlist.name);

      emit(RemoveFromWishListSuccess());
    } else {
      emit(RemoveFromWishListFailure(
          ApiErrorModel(message: 'No internet connection')));
    }
  }
}
