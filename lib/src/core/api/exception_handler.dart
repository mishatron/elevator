import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'exception_manager.dart';

void handleError(DioError error, JsonDecoder _decoder) {
  if (error.error is SocketException)
    throw error.error;
  else if (error.type == DioErrorType.RECEIVE_TIMEOUT ||
      error.type == DioErrorType.SEND_TIMEOUT ||
      error.type == DioErrorType.CONNECT_TIMEOUT) {
    throw ConnectionTimeoutException();
  }
  else if (error.response.statusCode < 200) {
    throw FetchingDataException();
  }
  else if (error.response.statusCode >= 400) {
    throw exceptions[error.response.statusCode](error.response.toString());
  }
}
