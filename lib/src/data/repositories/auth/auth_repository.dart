import 'package:elevator/src/core/base_repository.dart';
import 'package:elevator/src/domain/responses/user.dart';

abstract class AuthRepository extends BaseRepository {
  Future<bool> isUserLoggedIn();

  Future<void> logout();

  Future<User> getUser(String uid);
}
