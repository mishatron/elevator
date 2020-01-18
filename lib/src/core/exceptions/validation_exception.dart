class ValidationException implements Exception{
  String stringResource;

  /// Constructor, [stringResource]
  ValidationException(this.stringResource);
}