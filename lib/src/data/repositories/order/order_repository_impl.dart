import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/data/repositories/order/order_repository.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/history.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class OrderRepositoryImpl extends OrderRepository {
  @override
  Future<void> addCar(Car model) async {
    return Firestore.instance
        .collection('cars')
        .document(model.id)
        .setData(model.toJson());
  }

  @override
  Stream<QuerySnapshot> getCars() {
    return Firestore.instance.collection('cars').snapshots();
  }

  @override
  Future<void> addDriver(Driver model) async {
    return Firestore.instance
        .collection('drivers')
        .document(model.id)
        .setData(model.toJson());
  }

  @override
  Future<void> addOrder(Order model) async {
    return Firestore.instance
        .collection('orders')
        .document(model.id)
        .setData(model.toJson());
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

  @override
  Future<void> moveToHistory(Order order) async {
    await Firestore.instance.collection('orders').document(order.id).delete();
    String guardId = (await FirebaseAuth.instance.currentUser()).uid;
    History history = History(Uuid().v1(), order, guardId);
    await Firestore.instance
        .collection('history')
        .document(history.id)
        .setData(history.toJson());
  }
}
