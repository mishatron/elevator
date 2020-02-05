import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/router/route_paths.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/view/main/home/home_bloc.dart';
import 'package:elevator/src/view/main/home/tabs/entered_tab.dart';
import 'package:elevator/src/view/main/home/tabs/left_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseStatefulScreen<HomeScreen>
    with BaseBlocListener, SingleTickerProviderStateMixin {
  HomeBloc _bloc = HomeBloc();
  ScrollController _hideButtonController;
  bool _isFabVisible = true;

  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible == true) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isFabVisible == false) {
            setState(() {
              _isFabVisible = true;
            });
          }
        }
      }
    });
    tabs.add(EnteredTab(_hideButtonController));
    tabs.add(LeftTab(_hideButtonController));
  }

  @override
  Widget buildAppbar() {
    return getAppBar(context, 'Головна',
        bottom: TabBar(
          labelColor: colorAccent,
          indicatorColor: colorAccent,
          labelStyle: getMidFont(),
          tabs: <Widget>[
            Tab(
              child: Text('Заїзд'),
            ),
            Tab(
              child: Text('Виїзд'),
            ),
          ],
        ));
  }

  @override
  Widget getLayout() {
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          key: scaffoldKey,
          appBar: buildAppbar(),
          body: buildBody(),
          floatingActionButton: AnimatedOpacity(
              opacity: _isFabVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: FloatingActionButton(
                backgroundColor: colorAccent,
                child: Icon(Icons.add),
                onPressed: addButtonHandler,
              )),
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
  }

  @override
  Widget buildBody() {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener(
        bloc: _bloc,
        listener: blocListener,
        child: BlocBuilder<HomeBloc, DoubleBlocState>(
          builder: (context, state) {
            return TabBarView(
              children: tabs,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void addButtonHandler() {
    injector<NavigationService>().pushNamed(createOrderRoute);
  }
}
