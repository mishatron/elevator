import 'package:elevator/src/core/ui/base_stateless_widget.dart';
import 'package:flutter/material.dart';

class PlaceholderWidget extends BaseStatelessWidget{
  @override
  Widget getLayout(BuildContext context) {
   return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: <Widget>[
       Image.asset("assets/placeholder.png"),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text("Немає записів"),
       )
     ],
   );
  }

}