mixin AcceptionOrderValidator {
  bool canAcceptOrder(List<bool> stamps) {
    bool res = true;
    stamps.forEach((bool stamp) {
      if (!stamp) {
        res = false;
      }
    });
    return res;
  }
}
