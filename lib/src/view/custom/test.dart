import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Test extends StatelessWidget {
  final int level;
  final int curP;
  final int maxP;
  final Color backgroundColor;
  final Color progressColor;

  const Test(
      {Key key,
      this.level,
      this.curP,
      this.maxP,
      this.backgroundColor,
      this.progressColor})
      : super(key: key);

  final double height = 26.0;
  final double circlePadding = 3.0;

  Widget getLeftCircle() {
    Color colorCircle = progressColor;
    if (curP > 0) colorCircle = backgroundColor;
    return Container(
      margin: const EdgeInsets.only(left: 3, top: 3),
      width: height - circlePadding * 2,
      height: height - circlePadding * 2,
      child: Center(
        child: Text(
          "$level",
          textAlign: TextAlign.center,
          style: TextStyle(color: colorCircle),
        ),
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorCircle, width: 2.0)),
    );
  }

  Widget getRightCircle() {
    Color colorCircle = backgroundColor;
    if (curP < maxP) colorCircle = progressColor;
    return Container(
      margin: const EdgeInsets.only(right: 3, top: 3),
      width: height - circlePadding * 2,
      height: height - circlePadding * 2,
      child: Center(
        child: Text(
          "$level",
          textAlign: TextAlign.center,
          style: TextStyle(color: colorCircle),
        ),
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorCircle, width: 2.0)),
    );
  }

  Widget getProgressText(double fullWidth) {
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: "$curP",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    double textlen = renderParagraph.getMinIntrinsicWidth(15).ceilToDouble();
    RenderParagraph renderParagraph2 = RenderParagraph(
      TextSpan(
        text: " / $maxP",
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    double textlen2 = renderParagraph2.getMinIntrinsicWidth(15).ceilToDouble();

    double textWidth = textlen + textlen2;

    double progressWidth = getProgressWidth(fullWidth);

    double centerText = fullWidth / 2;


    if (progressWidth < centerText-textWidth)
      {
        return Positioned(
            left: progressWidth+height+5,
            bottom: 0,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "$curP",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  " / $maxP",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ));
      }

      return Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          top: 0,
          child: Center(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "$curP",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                " / $maxP",
                style: TextStyle(fontSize: 15),
              ),
            ],
          )));
  }

  double getProgressWidth(double fullWidth) {
    double workWidth = fullWidth - height * 2;
    double progress = curP / maxP;
    double progressWidth = progress * workWidth;
    return progressWidth;
  }

  Widget getProgress(double fullWidth) {
    double progressToSet = getProgressWidth(fullWidth) + height;
    if (curP == 0) progressToSet = 0;
    if (curP == maxP) progressToSet += height;
    return Container(
        height: height,
        width: progressToSet,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.redAccent,
            border: Border()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 2 / 3;

    return Stack(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border()),
        ),
        getProgress(width),
        Positioned(left: 0, top: 0, child: getLeftCircle()),
        Positioned(right: 0, top: 0, child: getRightCircle()),
        getProgressText(width)
      ],
    );
  }
}
