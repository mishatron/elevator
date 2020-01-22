import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/view/custom/bottom_menu/fancy_bottom_navigation.dart';
import 'package:elevator/src/view/main/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends BaseStatefulScreen<MainScreen> {
  ValueNotifier<int> _currentIndex = ValueNotifier(0);
  List<Widget> _children = [
    Container(),
    Container(),
    ProfileScreen(),
  ];

  @override
  Widget getLayout() {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: buildAppbar(),
        body: buildBody(),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: getBottomMenu(),
      ),
    );
  }

  Widget getBottomMenu() {
    return FancyBottomNavigation(
      circleColor: colorAccent,
      inactiveIconColor: colorAccent,
      tabs: [
        TabData(iconData: Icons.home, title: "Головна"),
        TabData(iconData: Icons.history, title: "Історія"),
        TabData(iconData: Icons.account_circle, title: "Профіль"),
      ],
      onTabChangedListener: (position) {
        _currentIndex.value = position;
      },
    );
  }

  @override
  Widget buildAppbar() {
    return null;
  }

  @override
  Widget buildBody() {
    return ValueListenableBuilder(
      valueListenable: _currentIndex,
      builder: (context, int value, child) {
        return _children[value];
      },
    );
  }
}
