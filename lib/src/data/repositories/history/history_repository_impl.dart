import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/data/repositories/history/history_repository.dart';

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
}
