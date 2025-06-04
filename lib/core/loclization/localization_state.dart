part of 'localization_cubit.dart';

@immutable
sealed class LocalizationState {}

final class LocalizationInitial extends LocalizationState {}

class LocalizationChanged extends LocalizationState {
  final Locale locale;
  LocalizationChanged(this.locale);
}
