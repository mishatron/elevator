import 'package:elevator/src/data/repositories/auth/auth_repository.dart';
import 'package:elevator/src/data/repositories/auth/auth_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/src/core/api/dio_manager.dart';

enum Flavor { MOCK, DEV, PROD }

GetIt injector = GetIt.instance;

/// Simple DI
class InjectorDI {
  static final InjectorDI singleton = InjectorDI._internal();
  Flavor flavor;

  InjectorDI._internal();

  /// init configuration
  void configure(Flavor flavor) {
    assert(flavor != null);
    flavor = flavor;

    if (flavor == Flavor.DEV) {
      DioManager.BASE_URL = "https://api.matchpool.com/api/";
    } else if (flavor == Flavor.PROD) {
      DioManager.BASE_URL = "https://api.matchpool.com/api/";
    }

    injector.registerLazySingleton(() => NavigationService());

    injector.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

    DioManager.configure();
  }

  factory InjectorDI() {
    return singleton;
  }
}
