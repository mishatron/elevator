import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/base_repository.dart';
import 'package:elevator/src/domain/responses/order/order.dart';

abstract class HistoryRepository extends BaseRepository {
  Stream<QuerySnapshot> getInputOrders();

  Stream<QuerySnapshot> getOutputOrders();

  Future<List<Order>> getInputOrdersFiltered(DateTime filter);

  Future<List<Order>> getOutputOrdersFiltered(DateTime filter);

  Future<List<Order>> getFilteredByNumber(String carNumber, int type);
}
