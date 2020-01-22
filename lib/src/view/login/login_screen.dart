import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/view/login/login_bloc.dart';
import 'package:elevator/src/view/login/phone_section.dart';
import 'package:elevator/src/view/login/verify_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends BaseStatefulScreen<LoginScreen>
    with BaseBlocListener {
  LoginBloc _bloc = LoginBloc();

  @override
  Widget buildAppbar() {
    return null;
  }

  @override
  Widget buildBody() {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener(
        bloc: _bloc,
        listener: blocListener,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                child: Text(
                  'ВХІД',
                  style: TextStyle(color: colorAccent, fontSize: 40),
                ),
              ),
              BlocBuilder<LoginBloc, DoubleBlocState>(
                builder: (context, state) {
                  if (state.lastSuccessState is LoginStatePhone) {
                    return PhoneSignInSection();
                  } else {
                    return VerifySection();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
