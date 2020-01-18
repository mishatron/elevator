import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/view/splash/splash_bloc.dart';

import 'splash_timer_mixin.dart';

class SplashScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends BaseStatefulScreen<SplashScreen>
    with SplashTimerMixin, SingleTickerProviderStateMixin {
  final SplashBloc _bloc = SplashBloc();
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );

    animationController.repeat(reverse: true, min: 0.1);

    startTimeout();
  }

  Widget buildBody() {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<SplashBloc, DoubleBlocState>(
        listener: (context, DoubleBlocState state) {
          if (state.errorState != null) {
            onError(state.errorState.exception);
          } else if (state.lastSuccessState is SplashRouteState) {
            nextRoute = (state.lastSuccessState as SplashRouteState).routeName;
          }
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Center(
                child: ScaleTransition(
                    scale: animation,
                    child: Image.asset('assets/ic_logo.png')))),
      ),
    );
  }

  @override
  Widget buildAppbar() {
    return null;
  }

  @override
  void dispose() {
    _bloc.close();
    animationController.dispose();
    super.dispose();
  }
}
