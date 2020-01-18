
import 'package:dio/dio.dart';
import 'package:elevator/src/core/api/exception_manager.dart';
import 'package:elevator/src/data/sources/local/preference_manager.dart';

class TokenInterceptor extends InterceptorsWrapper {
  Dio previous;
  Dio refreshDio = Dio();

  TokenInterceptor(previous) {
    this.previous = previous;
  }

  @override
  onRequest(RequestOptions options) async {
    String accessToken = await PreferenceManager().getAccessToken();

    if (accessToken == null) {
      await logout();
    }

    options.headers["Authorization"] = "Bearer $accessToken";
    return options;
  }

  logout() async {
    await PreferenceManager().clear();
    throw UnauthorizedException("Token not found");
  }

  @override
  Future<Response> onResponse(Response response) async {
    return response;
  } // 200 && 201 OK


  @override
  onError(DioError error) async {
    // Assume 401 stands for token expired
//    if (error.response?.statusCode ==
//        401 /* && error.response?.data['sub_status'] == 42*/) {
//      RequestOptions options = error.request;
//
//      // If the token has been updated, repeat directly.
//      String accessToken = await PreferenceManager().getAccessToken();
//
//      String token = "Bearer $accessToken";
//      if (token != options.headers["Authorization"]) {
//        options.headers["Authorization"] = token;
//        return previous.request(options.path, options: options);
//      }
//
//      // Lock to block the incoming request until the token updated
//      previous.lock();
//      previous.interceptors.responseLock.lock();
//      previous.interceptors.errorLock.lock();
//
//      try {
//        // GET the [refresh token] from shared or LocalStorage or ....
//        String refreshToken = await PreferenceManager().getRefreshToken();
//
//        // TODO: check if this is ok solution
//        AuthProto _authService = InjectorDI().injector.get<AuthProto>();
//        await _authService.refreshToken(refreshToken);
//
//        previous.unlock();
//        previous.interceptors.responseLock.unlock();
//        previous.interceptors.errorLock.unlock();
//
//        // repeat the request with a new options
//        return previous.request(options.path, options: options);
//      } catch (e) {
//        logout();
//      }
//    }
    return error;
  }
}
