import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:elevator/res/values/strings.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/src/core/localization/app_localizations.dart';

Widget getProgress({bool wrap = false, bool background = true}) {
  Widget getChild() {
    if (Platform.isAndroid)
      return CircularProgressIndicator();
    else if (Platform.isIOS)
      return CupertinoActivityIndicator(
        animating: true,
        radius: 20,
      );
    return null;
  }

  if (wrap) {
    return Center(
      heightFactor: 0,
      child: getChild(),
    );
  }
  return Stack(children: <Widget>[
    background
        ? Container(
            color: Color.fromARGB(160, 0, 0, 0),
          )
        : Offstage(),
    Center(
      child: getChild(),
    )
  ]);
}

Widget getRoundedImage(double radius, {ImageProvider im, Widget child}) {
  assert(radius != null);
  //TODO maybe fix it
  if (im != null)
    return Container(
        width: radius * 2.0,
        height: radius * 2.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(fit: BoxFit.cover, image: im)));
  else
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
}

void showAlert(BuildContext context, String title, String msg, Function onOk,
    {Function onCancel}) {
  assert(context != null);
  assert(title != null);
  assert(msg != null);
  assert(onOk != null);

  if (Platform.isAndroid) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            title,
            style: getBigFont(),
          ),
          content: Text(
            msg,
            style: getMidFont(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                Localization.of(context).getValue(cancel),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) {
                  onCancel();
                }
              },
            ),
            FlatButton(
              child: Text(
                Localization.of(context).getValue(ok),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onOk();
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          CupertinoDialogAction(
            child: Text(Localization.of(context).getValue(cancel)),
            onPressed: () {
              Navigator.of(context).maybePop();
              if (onCancel != null) {
                onCancel();
              }
            },
          ),
          CupertinoDialogAction(
            child: Text(Localization.of(context).getValue(ok)),
            onPressed: () {
              Navigator.of(context).maybePop();
              onOk();
            },
          )
        ],
      ),
    );
  }
}

Widget getBack() => BackButton(color: Colors.black,);

AppBar getAppBar(BuildContext context, String title,
    {Widget leading, List<Widget> actions, PreferredSizeWidget bottom}) {
  assert(context != null);
  assert(title != null);

  return AppBar(
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    leading: leading,
    title: Text(
      title,
      style: getAppBarTheme(context),
    ),
    actions: actions,
    bottom: bottom,
  );
}
