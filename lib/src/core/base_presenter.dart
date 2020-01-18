/// every contract should be inherited from this
abstract class BaseContract{
  /// function to handling global exceptions in base class
  /// exceptions like: no internet, socket timeout
  void onError(Object e);
  void onShowProgress();
  void onHideProgress();
  void onShowMessage(String msg);
}

/// every presenter should be inherited from this
abstract class BasePresenter{
}