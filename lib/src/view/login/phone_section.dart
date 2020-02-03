import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/strings.dart';
import 'package:elevator/res/values/styles.dart';
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

class PhoneSignInSection extends BaseStatefulWidget {
  PhoneSignInSection();

  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends BaseState<PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var _auth = FirebaseAuth.instance;

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _focusNode.unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/login_placeholder.png"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _phoneNumberController,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              decoration:
                  getTextFieldDecoration(context, 'Введіть номер телефону'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Формат: (+x xxx-xxx-xxxx)';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BaseButton(
              text: 'Далі',
              onClick: _verifyPhoneNumber,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Натискаючи кнопку “Далі”, я приймаю умови Політики конфіденційності.",
              textAlign: TextAlign.center,
              style: getSmallFont().apply(color: colorAccent),
            ),
          )
        ],
      ),
    );
  }

  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      showMessage("Ви авторизовані тепер");
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      if (authException.message.contains("A network error"))
        onShowMessage(noInternetError);
      else
        showMessage("Ви ввели невірний номер телефону");
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showMessage("Очікуйте смс");
      _bloc.add(LoginStateVerification());
      _bloc.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _bloc.verificationId = verificationId;
    };

    if (_phoneNumberController.text.isNotEmpty) {
      hideKeyboard();
      _bloc.add(LoadingState());

      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

      _bloc.add(NoLoadingState());
    }
  }
}
