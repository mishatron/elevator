import 'package:flutter/material.dart';
import 'package:elevator/src/core/localization/app_localizations.dart';

InputDecoration getTextFieldDecoration(
    BuildContext context, String hintTextRes) {
  return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.redAccent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.redAccent)),
      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
      labelText: Localization.of(context).getValue(hintTextRes));
}
