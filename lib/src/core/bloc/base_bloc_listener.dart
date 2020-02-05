import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/loading_state.dart';
import 'package:elevator/src/core/bloc/message_state.dart';
import 'package:elevator/src/core/bloc/no_loading_state.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:flutter/cupertino.dart';

mixin BaseBlocListener<T extends BaseStatefulWidget> on BaseState<T> {
  void blocListener(BuildContext context, DoubleBlocState state) {
    if (state.errorState != null) {
      onError(state.errorState.exception);
    } else if (state.lastSuccessState is LoadingState) {
      showProgress();
    } else if (state.lastSuccessState is NoLoadingState) {
      hideProgress();
    } else if (state.lastSuccessState is MessageState) {
      if ((state.lastSuccessState as MessageState).text != null) {
        showMessage((state.lastSuccessState as MessageState).text);
      } else if ((state.lastSuccessState as MessageState).textRes != null) {
        onShowMessage((state.lastSuccessState as MessageState).textRes);
      }
    }
  }
}
