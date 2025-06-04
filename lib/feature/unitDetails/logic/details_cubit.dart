
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit() : super(DetailsInitial());
  static DetailsCubit get(context) => BlocProvider.of(context);

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int newIndex) {
    _currentIndex = newIndex;
    emit(DetailsIndexChanged(newIndex));
  }

  void nextPage() {
    _currentIndex++;
    emit(DetailsIndexChanged(_currentIndex));
  }

  void previousPage() {
    _currentIndex--;
    emit(DetailsIndexChanged(_currentIndex));
  }
}
