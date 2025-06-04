part of 'fav_cubit.dart';

@immutable
sealed class FavState {}

final class FavInitial extends FavState {}
final class AddToWishListLoading extends FavState {}

final class AddToWishListSuccess extends FavState {}

final class AddToWishListFailure extends FavState {
  final ApiErrorModel error;
  AddToWishListFailure( this.error);
}

final class GetWishListLoading extends FavState {}

final class GetWishListSuccess extends FavState {}

final class GetWishListFailure extends FavState {
  final ApiErrorModel error;
  GetWishListFailure( this.error);
}

final class RemoveFromWishListLoading extends FavState {}

final class RemoveFromWishListSuccess extends FavState {}

final class RemoveFromWishListFailure extends FavState {
  final ApiErrorModel error;
  RemoveFromWishListFailure( this.error);
}