import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/order.dart';

class OrderRepositoryImpl extends OrderRepository {
  @override
  Future<String> addCar(Car model) async {
    return Firestore.instance
        .collection('cars')
        .add(model.toJson())
        .then((DocumentReference ref) {
      return ref.documentID;
    });
  }

  @override
  Future<String> addDriver(Driver model) async {
    return Firestore.instance
        .collection('drivers')
        .add(model.toJson())
        .then((DocumentReference ref) {
      return ref.documentID;
    });
  }

  @override
  Future<String> addOrder(Order model) async {
    return Firestore.instance
        .collection('orders')
        .add(model.toJson())
        .then((DocumentReference ref) {
      return ref.documentID;
    });
  }

  @override
  Stream<QuerySnapshot> getInputOrders() {
    return Firestore.instance
        .collection('orders')
        .where("type", isEqualTo: 0)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> getOutputOrders() {
    return Firestore.instance
        .collection('orders')
        .where("type", isEqualTo: 1)
        .snapshots();
  }
}
