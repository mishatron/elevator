import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';

class LoginStatePhone extends BaseBlocState {}

class LoginStateVerification extends BaseBlocState {}

class LoginBloc extends BaseBloc<BaseBlocState, DoubleBlocState> {
  @override
  DoubleBlocState get initialState => DoubleBlocState(LoginStatePhone(), null);

  String verificationId;
}
