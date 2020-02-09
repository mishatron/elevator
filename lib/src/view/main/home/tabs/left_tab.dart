import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/main/home/home_bloc.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:elevator/src/view/placeholder/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeftTab extends BaseStatefulWidget {
  final ScrollController hideButtonController;

  LeftTab(this.hideButtonController);

  @override
  State<StatefulWidget> createState() {
    return _LeftTabState();
  }
}

class _LeftTabState extends BaseState<LeftTab> {
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return StreamBuilder(
      stream: _bloc.getOutputOrders(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return getProgress(background: false);
        else if(snapshot.data.documents.isEmpty)return PlaceholderWidget();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          controller: widget.hideButtonController,
          itemBuilder: (context, index) {
            return ListItem(
                Order.fromJsonMap(snapshot.data.documents[index].data));
          },
        );
      },
    );
  }
}
