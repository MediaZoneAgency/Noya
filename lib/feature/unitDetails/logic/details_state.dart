part of 'details_cubit.dart';

@immutable
sealed class DetailsState {}

final class DetailsInitial extends DetailsState {}

final class DetailsIndexChanged extends DetailsState {
  final int index;

  DetailsIndexChanged(this.index);
}
