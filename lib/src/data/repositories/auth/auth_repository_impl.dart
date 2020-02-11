import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/data/repositories/auth/auth_repository.dart';
import 'package:elevator/src/domain/responses/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl() {}

  var _auth = FirebaseAuth.instance;

  @override
  Future<bool> isUserLoggedIn() async {
    return (await _auth.currentUser()) != null;
  }

  @override
  Future<void> logout() async {
    return await _auth.signOut();
  }

  @override
  Future<User> getUser(String uid) async {
    DocumentSnapshot ds =
        await Firestore.instance.collection('users').document(uid).get();
    if (ds.exists) {
      return User.fromJsonMap(ds.data);
    } else {
      DocumentSnapshot ds2 = await Firestore.instance
          .collection('users')
          .document("6O7I2vef9aS68QWFRgp7")
          .get();
      if (ds2.exists) {
        return User.fromJsonMap(ds2.data);
      } else
        return null;
    }
  }
}
