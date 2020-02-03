import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/core/bloc/message_state.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/order_detail/acception_order_validator.dart';

class OrderDetailsBloc extends BaseBloc<BaseBlocState, DoubleBlocState>
    with AcceptionOrderValidator {
  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  Order _order;
  List<bool> stamps = [];

  Order get order => _order;

  set order(Order value) {
    _order = value;
    stamps = List.filled(value.stamps.length, false);
  }

  void accept() {
    if(canAcceptOrder(stamps)){

      add(MessageState(text: "Типу прийнято"));
    }
    else add(MessageState(text: "Підтвердіть цілісність плом, або відхиліть прибуття вантажу"));
  }
}
