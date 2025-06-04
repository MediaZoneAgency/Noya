part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}


final class SearchSuccess extends SearchState {}

final class SearchLoading extends SearchState {}
final class MinPriceChange extends SearchState{}

final class MaxPriceChange extends SearchState{}
final class SearchFailure extends SearchState {
  final ApiErrorModel error;

  SearchFailure(this.error);
}
