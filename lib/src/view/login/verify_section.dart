import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/router/route_paths.dart';
import 'package:elevator/src/core/bloc/loading_state.dart';
import 'package:elevator/src/core/bloc/no_loading_state.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
import 'package:elevator/src/view/login/login_bloc.dart';
import 'package:elevator/src/view/utils/text_field_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifySection extends BaseStatefulWidget {
  VerifySection();

  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends BaseState<VerifySection> {
  final TextEditingController _smsController = TextEditingController();
  var _auth = FirebaseAuth.instance;
  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/login_placeholder.png"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
                controller: _smsController,
                decoration:
                    getTextFieldDecoration(context, "Введіть код підтвердження")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: BaseButton(
              onClick: _signInWithPhoneNumber,
              text: "Підтвердити",
            ),
          ),
        ],
      ),
    );
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    hideKeyboard();
    _bloc.add(LoadingState());
    try {
      if (_smsController.text.isNotEmpty) {
        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _bloc.verificationId,
          smsCode: _smsController.text,
        );
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        if (user != null) {
          injector<NavigationService>().pushNamedReplacement(mainRoute);
        } else {
          showMessage("Невірний код");
        }
      } else {
        showMessage("Введіть код");
      }
    } catch (err) {
      print(err);
      showMessage("Помилка входу. Перевірте код та номер телефону");
    }
    _bloc.add(NoLoadingState());
  }
}
