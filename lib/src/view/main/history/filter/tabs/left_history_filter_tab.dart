import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/view/main/history/filter/history_filter_bloc.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:elevator/src/view/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeftHistoryFilterTab extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeftHistoryFilterTabState();
  }
}

class _LeftHistoryFilterTabState extends BaseState<LeftHistoryFilterTab> {
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
        if (_bloc.output == null) return getProgress(background: false);
        else if(_bloc.output.isEmpty)return PlaceholderWidget();
        return ListView.builder(
          itemCount: _bloc.output.length,
          itemBuilder: (context, index) {
            return ListItem(_bloc.output[index]);
          },
        );
      },
    );
  }
}
