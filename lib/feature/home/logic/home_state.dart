part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class ChangeCurrentPageRequest extends HomeState {}
class FetchUnitsInitial extends HomeState {}
class FetchUnitsSuccess extends HomeState {
  final List<UnitModel> units;
  FetchUnitsSuccess(this.units);
}



class FetchUnitsLoading extends HomeState {}

class FetchUnitsFailure extends HomeState {
  final String errorMessage;
 FetchUnitsFailure(this.errorMessage);
}
class ChangeCurrentCategory extends HomeState {}
//