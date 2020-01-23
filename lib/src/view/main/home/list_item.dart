import 'package:elevator/res/values/colors.dart';
import 'package:elevator/src/view/utils/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ListItem extends StatelessWidget {
  final String carNumber;
  final String carModel;
  final String grains;
  final String name;
  final String phoneNumber;
  final String imageUrl;
  final Function onTap;

  ListItem(
      {this.carNumber,
      this.carModel,
      this.grains,
      this.name,
      this.phoneNumber,
      this.imageUrl,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: colorAccent, width: 1)),
        child: ListTile(
          onTap: onTap,
          leading: getUserAvatar(imageUrl, 50),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: colorAccent, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        carNumber,
                        style: TextStyle(color: colorAccent, fontSize: 14),
                      ),
                    ),
                  ),
                  Text(
                    carModel,
                    style: TextStyle(color: colorAccent, fontSize: 16),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  grains,
                  style: TextStyle(color: colorAccent, fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        color: colorAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      color: colorAccent,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
