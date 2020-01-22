import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/values/colors.dart';

Widget _getUserImagePlaceholder(double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: colorAccent, width: 1),
      image: DecorationImage(
        image: AssetImage("assets/ic_avatar.png"),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget getUserAvatar(String url, double size){
  return CachedNetworkImage(
    imageUrl: url ?? "",
    imageBuilder: (context, imageProvider) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorAccent, width: 1),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) {
      return _getUserImagePlaceholder(size);
    },
    errorWidget: (context, url, err) {
      return _getUserImagePlaceholder(size);
    },
  );
}

Widget getPoolImagePlaceholder() {
  return AspectRatio(
    aspectRatio: 3 / 2,
    child: Container(
        color: Colors.blue,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Image.asset(
            "assets/ic_logo.png",
          ),
        )),
  );
}