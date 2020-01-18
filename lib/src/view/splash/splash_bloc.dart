import 'package:elevator/router/route_paths.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/core/bloc/error_state.dart';
import 'package:elevator/src/data/repositories/auth/auth_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';

abstract class SplashState extends BaseBlocState {}

class SplashRouteState extends SplashState {
  final String routeName;

  SplashRouteState(this.routeName);
}

class SplashBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  AuthRepository _authRepository;

  SplashBloc() {
    _authRepository = injector.get();
    getUserIsLoggedIn();
  }

  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  void getUserIsLoggedIn() {
    _authRepository.isUserLoggedIn().then((res) {
      if (res)
        add((SplashRouteState(mainRoute)));
      else
        add((SplashRouteState(loginRoute)));
    }).catchError((err) {
      add(ErrorState(err));
    });
  }
}
