import 'package:flutter/material.dart';

/// every StatelessWidget should be inherited from this
abstract class BaseStatelessWidget extends StatelessWidget{
  Widget getLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return getLayout(context);
  }
}