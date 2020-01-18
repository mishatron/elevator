/// custom exception for throwing in [Localization] class
class LocalizationException implements Exception {
  final String msg;

  /// constructor of exception
  LocalizationException(this.msg);
}
