import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/data/repositories/history/history_repository.dart';
import 'package:elevator/src/domain/responses/order/order.dart';

class HistoryRepositoryImpl extends HistoryRepository {
  @override
  Stream<QuerySnapshot> getInputOrders() {
    return Firestore.instance
        .collection('history')
        .where("type", isEqualTo: 0)
        .orderBy('timeStatus', descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> getOutputOrders() {
    return Firestore.instance
        .collection('history')
        .where("type", isEqualTo: 1)
        .orderBy('timeStatus', descending: true)
        .snapshots();
  }

  @override
  Future<List<Order>> getOutputOrdersFiltered(DateTime filter) {
    return Firestore.instance
        .collection('history')
        .where("type", isEqualTo: 1)
        .where('timeStatus',
            isGreaterThan:
                filter.subtract(const Duration(days: 1)).millisecondsSinceEpoch)
        .where('timeStatus',
            isLessThan:
                filter.add(const Duration(days: 1)).millisecondsSinceEpoch)
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents.map((doc) {
        return Order.fromJsonMap(doc.data);
      }).toList();
    });
  }

  @override
  Future<List<Order>> getInputOrdersFiltered(DateTime filter) {
    return Firestore.instance
        .collection('history')
        .where("type", isEqualTo: 0)
        .where('timeStatus',
            isGreaterThan:
                filter.subtract(const Duration(days: 1)).millisecondsSinceEpoch)
        .where('timeStatus',
            isLessThan:
                filter.add(const Duration(days: 1)).millisecondsSinceEpoch)
        .getDocuments()
        .then((snapshot) {
      return snapshot.documents.map((doc) {
        return Order.fromJsonMap(doc.data);
      }).toList();
    });
  }
}
