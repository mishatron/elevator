
import 'base_bloc_state.dart';

class ErrorState extends BaseBlocState {
  final Exception exception;

  ErrorState(this.exception);
}
