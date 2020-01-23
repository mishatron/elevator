import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/view/main/history/history_bloc.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryScreenState();
  }
}

class _HistoryScreenState extends BaseStatefulScreen<HistoryScreen>
    with BaseBlocListener {
  HistoryBloc _bloc = HistoryBloc();

  List<Widget> tabs = [Container(), Container()];

  @override
  Widget buildAppbar() {
    return getAppBar(context, 'Історія',
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
        child: BlocBuilder<HistoryBloc, DoubleBlocState>(
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
}
