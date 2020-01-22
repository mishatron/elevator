import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/router/route_paths.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/content_loading_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/core/bloc/loading_state.dart';
import 'package:elevator/src/core/bloc/no_loading_state.dart';
import 'package:elevator/src/data/repositories/auth/auth_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileLoadedState extends BaseBlocState {}

class ProfileBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  AuthRepository _authRepository = injector.get();
  User user;

  ProfileBloc() {
    loadUserData();
  }

  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  void loadUserData() async {
    add(ContentLoadingState());
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    user = await _authRepository.getUser(firebaseUser.uid);
    add(ProfileLoadedState());
  }

  void logout() async {
    add(LoadingState());
    await _authRepository.logout();
    add(NoLoadingState());
    injector<NavigationService>().pushAndRemoveAnother(splashRoute);
  }
}
