import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/core/localization/app_localizations.dart';

class BaseButton extends StatelessWidget {
  final String textRes;
  final String text;
  final Function onClick;
  final double radius;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;

  const BaseButton(
      {Key key,
      this.textRes,
      this.text,
      this.onClick,
      this.radius = 50.0,
      this.textColor = Colors.white,
      this.buttonColor = colorAccent,
      this.borderColor = colorAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minWidth: double.infinity, minHeight: 50.0),
      fillColor: buttonColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor)),
      child: Text(
        text ?? Localization.of(context).getValue(textRes),
        style: TextStyle(
            color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onClick,
    );
  }
}
