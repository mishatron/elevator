import 'package:elevator/res/values/colors.dart';
import 'package:flutter/material.dart';

InputDecoration getTextFieldDecoration(BuildContext context, String hintText) {
  return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: colorAccent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: colorAccent)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.redAccent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.redAccent)),
      labelStyle: TextStyle(fontSize: 16),
      labelText: hintText);
}
