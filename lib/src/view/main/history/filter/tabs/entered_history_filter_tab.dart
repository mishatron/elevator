import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/view/main/history/filter/history_filter_bloc.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnteredHistoryFilterTab extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnteredHistoryFilterTabState();
  }
}

class _EnteredHistoryFilterTabState extends BaseState<EnteredHistoryFilterTab> {
  HistoryFilterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return BlocBuilder<HistoryFilterBloc, DoubleBlocState>(
      builder: (BuildContext context, state) {
        if (_bloc.input == null) return getProgress(background: false);
        return ListView.builder(
          itemCount: _bloc.input.length,
          itemBuilder: (context, index) {
            return ListItem(_bloc.input[index]);
          },
        );
      },
    );
  }
}
