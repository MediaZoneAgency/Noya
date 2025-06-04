import 'package:bloc/bloc.dart';
import 'package:broker/feature/profie/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepo) : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  final ProfileRepo profileRepo;
  ProfileModel? profileUser;
  Future<void> getProfile() async {
    // profileUser = ProfileModel(
    //     name: 'test',
    //     email: 'test@gmail.com',
    //     phoneNumber: '0102020200',
    //     image:
    //         'https://wallpapers.com/images/featured/blank-white-7sn5o1woonmklx1h.jpg',
    //     role: 'test');
    emit(ProfileLoading());
    final result = await profileRepo.fetchProfile();
    {
      result.fold(
        (failure) {
          profileUser = null;
          emit(ProfileFailure(failure.message));
        },
        (profileApi) {
          profileUser = profileApi;
          emit(ProfileSuccess());
        },
      );
    }
  }
}
