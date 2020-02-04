import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/base_repository.dart';

abstract class HistoryRepository extends BaseRepository {
  Stream<QuerySnapshot> getInputOrders();

  Stream<QuerySnapshot> getOutputOrders();
}
