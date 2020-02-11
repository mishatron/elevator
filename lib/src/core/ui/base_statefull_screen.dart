import 'package:flutter/material.dart';

import 'base_state.dart';
import 'base_statefull_widget.dart';

abstract class BaseStatefulScreen<B extends BaseStatefulWidget>
    extends BaseState<B> {
  bool isMobile() => (MediaQuery.of(context).size.shortestSide < 600.0);

  @override
  Widget getLayout() {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: buildAppbar(),
        body: buildBody(),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  /// should be overridden in extended widget
  Widget buildAppbar();

  /// should be overridden in extended widget
  Widget buildBody();
}
