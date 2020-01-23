import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/base_repository.dart';
import 'package:elevator/src/domain/responses/car.dart';
import 'package:elevator/src/domain/responses/driver.dart';
import 'package:elevator/src/domain/responses/order/order.dart';

abstract class OrderRepository extends BaseRepository {
  Future<String> addCar(Car model);

  Future<String> addDriver(Driver model);

  Future<String> addOrder(Order model);

  Stream<QuerySnapshot> getInputOrders();

  Stream<QuerySnapshot> getOutputOrders();
}