class Pattern {
  static final String EMAIL_ADDRESS =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static final String GOOD_PASSWORD_PATTERN =
      r'^(?:(?=.*[a-z])(?:(?=.*[A-Z])(?=.*[\d\W])|(?=.*\W)(?=.*\d))|(?=.*\W)(?=.*[A-Z])(?=.*\d)).{8,}$';
  static final
  String PHONE_NUMBER = r'(^(?:[+0][0-9])?[0-9]{10,12}$)';
}

class Validator {
  static bool isEmail(String em) {
    RegExp regExp = RegExp(Pattern.EMAIL_ADDRESS);

    return regExp.hasMatch(em);
  }

  static bool isPassword(String pass) {
    RegExp regExp = RegExp(Pattern.GOOD_PASSWORD_PATTERN);

    return regExp.hasMatch(pass);
  }

  static bool isPhoneNumber(String value) {
    RegExp regExp = RegExp(Pattern.PHONE_NUMBER);
    return regExp.hasMatch(value);
  }
}
