import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/src/core/bloc/base_bloc.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/empty_bloc_state.dart';
import 'package:elevator/src/core/bloc/loading_state.dart';
import 'package:elevator/src/core/bloc/message_state.dart';
import 'package:elevator/src/core/bloc/no_loading_state.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/models/order_status.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/order_detail/acception_order_validator.dart';

class OrderDetailsBloc extends BaseBloc<BaseBlocState, DoubleBlocState>
    with AcceptionOrderValidator {
  @override
  DoubleBlocState get initialState => DoubleBlocState(EmptyBlocState(), null);

  OrderRepository _orderRepository = injector.get();

  Order _order;
  List<bool> stamps = [];

  Order get order => _order;
  bool get isHistory => _order.timeStatus!=-1 && _order.timeStatus!=null;

  set order(Order value) {
    _order = value;
    value.stamps.forEach((stamp) {
      stamps.add(stamp.stampStatus);
    });
  }

  void accept() async {
    if (canAcceptOrder(stamps)) {
      add(LoadingState());
      order.timeStatus = DateTime.now().millisecondsSinceEpoch;
      order.status = OrderStatus.ACCEPTED.index;
      for (int i = 0; i < stamps.length; ++i) {
        order.stamps[i].stampStatus = stamps[i];
      }
      await _orderRepository.moveToHistory(order);
      add(NoLoadingState());
      add(MessageState(text: "Операція успішно виконана"));
      injector<NavigationService>().goBack();
    } else
      add(MessageState(
          text: "Підтвердіть цілісність плом, або відхиліть прибуття вантажу"));
  }

  void decline() async {
    add(LoadingState());
    order.timeStatus = DateTime.now().millisecondsSinceEpoch;
    order.status = OrderStatus.DECLINED.index;
    for (int i = 0; i < stamps.length; ++i) {
      order.stamps[i].stampStatus = stamps[i];
    }
    await _orderRepository.moveToHistory(order);
    add(NoLoadingState());
    add(MessageState(text: "Операція успішно виконана"));
    injector<NavigationService>().goBack();
  }
}
