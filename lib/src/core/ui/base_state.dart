import 'dart:io';

import 'package:elevator/res/values/strings.dart';
import 'package:elevator/src/core/api/exception_manager.dart';
import 'package:elevator/src/core/base_presenter.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../exceptions/validation_exception.dart';
import '../localization/app_localizations.dart';
import 'base_statefull_widget.dart';

abstract class BaseState<B extends BaseStatefulWidget> extends State<B>
    implements BaseContract {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final Logger log = Logger();

  /// show progress bar
  void showProgress() {
    setState(() {
      _isLoading = true;
    });
  }

  /// hide progress bar
  void hideProgress() {
    if (_isLoading)
      setState(() {
        _isLoading = false;
      });
  }

  /// show message: toast on android or alert dialog on ios
  void showMessage(String message) {
    if (message == null) {
      return;
    }
    if (Platform.isIOS) {
//    Scaffold.of(context).hideCurrentSnackBar();
//      scaffoldKey.currentState.hideCurrentSnackBar();
//      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));

      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: new Text(ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// should be overridden in extended widget
  Widget getLayout();

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Stack(
        children: <Widget>[getLayout(), getProgress()],
      );
    }
    return getLayout();
  }

  /// error handler
  @override
  void onError(Object e,
      {StackTrace stackTrace, bool withHideProgress = true}) {
    if (e == null) return;
    if (withHideProgress) hideProgress();
    if (stackTrace != null) print(stackTrace);
    log.e(e);
    if (e is ValidationException) {
      showMessage(Localization.of(context).getValue(e.stringResource));
    } else if (e is ConnectionTimeoutException) {
      showMessage(Localization.of(context).getValue(noInternetError));
    } else if (e is UnauthorizedException) {
//      if (this is AuthScreenState) {
//        showMessage(e.msg);
//      } else
      Navigator.of(context).pushReplacementNamed("/");
    }
    if (e is ForbiddenException) {
      showMessage(e.msg);
    } else if (e is NotFoundException) {
      showMessage(e.msg);
    } else if (e is BadRequestException) {
      showMessage(e.msg);
    } else if (e is InternalServerErrorException) {
      showMessage(e.msg);
    } else if (e is FetchingDataException) {
      showMessage(e.msg);
    } else if (e is UnprocessableEntityException) {
      showMessage(e.msg);
    } else if (e is SocketException) {
      showMessage(Localization.of(context).getValue(noInternetError));
    }
    /*else if (e is WrongFileException) {
      showMessage(Localization.of(context).getValue(e.msgRes));
    } */
    else {
      showMessage(Localization.of(context).getValue(unexpectedError));
    }
  }

  @override
  void onHideProgress() {
    hideProgress();
  }

  @override
  void onShowProgress() {
    showProgress();
  }

  @override
  void onShowMessage(String msgRes) {
    showMessage(Localization.of(context).getValue(msgRes));
  }
}
