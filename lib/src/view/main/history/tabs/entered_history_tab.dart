import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/ui/base_state.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/history.dart';
import 'package:elevator/src/domain/responses/order/good.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/domain/responses/order/stamp.dart';
import 'package:elevator/src/view/main/history/history_bloc.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class EnteredHistoryTab extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnteredHistoryTabState();
  }
}

class _EnteredHistoryTabState extends BaseState<EnteredHistoryTab> {
  HistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget getLayout() {
    return StreamBuilder(
      stream: _bloc.getInputOrders(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return getProgress(background: false);
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return ListItem(
                History.fromJsonMap(snapshot.data.documents[index].data).order);
          },
        );
      },
    );
  }
}
