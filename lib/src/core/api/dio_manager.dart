import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elevator/src/core/api/exception_handler.dart';
import 'package:elevator/src/core/api/file_to_upload.dart';
import 'package:http/http.dart' as http;
import 'package:elevator/src/core/api/token_inteceptor.dart';

/// Timeout of API call
final Duration timeout = Duration(seconds: 10);

/// Class that makes API call easier
class DioManager {
  ///Do not change
  static String BASE_URL = "";
  Dio dio = Dio();

  static final DioManager singleton = DioManager._internal();

  DioManager._internal();

  factory DioManager() => singleton;

  static void configure() {
    singleton.dio.options
      ..baseUrl = BASE_URL
      ..connectTimeout = timeout.inMilliseconds
      ..receiveTimeout = 60000;

    TokenInterceptor tokenInterceptor = TokenInterceptor(singleton.dio);

    singleton.dio
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true))
      ..interceptors.add(tokenInterceptor);
  }

  /// Instance of decoder for decoding API results
  final JsonDecoder _decoder = JsonDecoder();

  /// DIO GET
  /// take [url], concrete route
  Future<Response> get(String url, {Map<String, dynamic> json}) async =>
      await dio
          .get(url, queryParameters: json)
          .then((response) => response)
          .catchError((error) {
        handleError(error, _decoder);
      });

  /// DIO POST
  /// take [url], concrete route
  Future<Response> post(String url, {Map headers, body, encoding}) async =>
      await dio
          .post(url, data: body)
          .then((response) => response)
          .catchError((error) {
        handleError(error, _decoder);
      });

  /// DIO POST MULTIPART
  /// take [url], concrete route
  Future<Response> postMultipart(String url,
      {Map headers, body, encoding, List<FileToUpload> files}) async {
    List<http.MultipartFile> filesToUpload = [];
    for (var file in files) {
      filesToUpload
          .add(await http.MultipartFile.fromPath(file.field, file.path));
    }

    var dataToUpload = FormData.fromMap(body + {"files": filesToUpload});
    return await dio
        .post(url, data: dataToUpload)
        .then((response) => response)
        .catchError((error) {
      handleError(error, _decoder);
    });
  }

  /// DIO PUT
  /// take [url], concrete route
  Future<Response> put(String url, {Map headers, body, encoding}) async =>
      await dio.put(url, data: body).then((response) {
        return response;
      }).catchError((error) {
        handleError(error, _decoder);
      });

  /// DIO DELETE
  /// take [url], concrete route
  Future<Response> delete(String url, {Map headers, body, encoding}) async =>
      await dio.delete(url, data: body).then((response) {
        return response;
      }).catchError((error) {
        handleError(error, _decoder);
      });
}
