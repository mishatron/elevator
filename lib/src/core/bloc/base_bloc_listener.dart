import 'package:flutter/cupertino.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/loading_state.dart';
import 'package:elevator/src/core/bloc/no_loading_state.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';

mixin BaseBlocListener<T extends BaseStatefulWidget> on BaseState<T> {
  void blocListener(BuildContext context, DoubleBlocState state) {
    if (state.errorState != null) {
      onError(state.errorState.exception);
    } else if (state.lastSuccessState is LoadingState) {
      showProgress();
    }
    else if (state.lastSuccessState is NoLoadingState){
      hideProgress();
    }
  }
}
