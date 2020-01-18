import 'package:flutter/material.dart';

import 'base_stateless_widget.dart';

abstract class BaseStatelessScreen extends BaseStatelessWidget {
  @override
  Widget getLayout(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppbar(context),
        body: buildBody(context),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  /// should be overridden in extended widget
  Widget buildAppbar(BuildContext context);

  /// should be overridden in extended widget
  Widget buildBody(BuildContext context);
}
