import 'package:after_layout/after_layout.dart';
import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bundle.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/view/main/history/filter/history_filter_bloc.dart';
import 'package:elevator/src/view/main/history/filter/tabs/entered_history_filter_tab.dart';
import 'package:elevator/src/view/main/history/filter/tabs/left_history_filter_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryFilterScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryFilterScreenState();
  }
}

class _HistoryFilterScreenState extends BaseStatefulScreen<HistoryFilterScreen>
    with BaseBlocListener, AfterLayoutMixin<HistoryFilterScreen> {
  HistoryFilterBloc _bloc = HistoryFilterBloc();

  List<Widget> tabs = [EnteredHistoryFilterTab(), LeftHistoryFilterTab()];

  @override
  Widget buildAppbar() {
    return getAppBar(context, 'Історія',
        leading: getBack(),
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
        child: BlocBuilder<HistoryFilterBloc, DoubleBlocState>(
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

  @override
  void afterFirstLayout(BuildContext context) {
    _bloc.loadFilteredData((ModalRoute.of(context).settings.arguments as Bundle)
        .getDynamic("date") as DateTime);
  }
}
