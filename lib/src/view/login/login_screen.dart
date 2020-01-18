import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/view/login/phone_section.dart';
import 'package:flutter/material.dart';

class LoginScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends BaseStatefulScreen<LoginScreen> {
  @override
  Widget buildAppbar() {
    return null;
  }

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          PhoneSignInSection()
        ],
      ),
    );
  }
}
