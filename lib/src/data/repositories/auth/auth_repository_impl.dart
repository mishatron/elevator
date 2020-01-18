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
  Future<User> getUser(String uid) {
    return Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot ds) {
      return User.fromJsonMap(ds.data);
    });
  }

}
