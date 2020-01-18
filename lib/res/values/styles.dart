import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData buildThemeData() {
  final baseTheme = ThemeData.light();

  return baseTheme.copyWith(
      primaryColor: colorPrimary,
      accentColor: colorAccent,
      primaryColorDark: colorPrimaryDark,
      scaffoldBackgroundColor: Colors.white,
      primaryTextTheme:
      _buildTextTheme(baseTheme.primaryTextTheme, colorPrimaryText),
      buttonColor: colorPrimary,
      textTheme: _buildTextTheme(baseTheme.textTheme, colorPrimaryText));
}

TextTheme _buildTextTheme(TextTheme base, Color color) {
  return base
      .copyWith(
      headline: base.headline.copyWith(fontWeight: FontWeight.w500),
      title: base.title.copyWith(fontSize: 18.0),
      caption: base.caption
          .copyWith(fontWeight: FontWeight.w400, fontSize: 14.0))
      .apply(fontFamily: "Heboo", displayColor: color, bodyColor: color);
}

TextStyle getAppBarTheme(BuildContext context){
  return Theme.of(context)
      .copyWith()
      .textTheme
      .title
      .copyWith(color: colorPrimaryText);
}



// black fonts
TextStyle getVeryBigFont(){
  return const TextStyle(fontSize: 24,color: Colors.black);
}
TextStyle getBigFont(){
  return const TextStyle(fontSize: 20,color: Colors.black);
}
TextStyle getMidFont(){
  return const TextStyle(fontSize: 16,color: Colors.black);
}
TextStyle getSmallFont(){
  return const TextStyle(fontSize: 14,color: Colors.black);
}
TextStyle getMidFontBold(){
  return const TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold);
}
TextStyle getVerySmallFont(){
  return const TextStyle(fontSize: 12,color: Colors.black);
}



// white fonts
TextStyle getBigFontWhite(){
  return const TextStyle(fontSize: 20,color: Colors.white);
}
TextStyle getMidFontWhite(){
  return const TextStyle(fontSize: 16,color: Colors.white);
}
TextStyle getSmallFontWhite(){
  return const TextStyle(fontSize: 14,color: Colors.white);
}

// grey fonts
TextStyle getMidFontGrey(){
  return const TextStyle(fontSize: 16,color: colorTextGrey);
}
TextStyle getSmallFontGrey(){
  return const TextStyle(fontSize: 14,color: colorTextGrey);
}
TextStyle getVerySmallFontGrey(){
  return const TextStyle(fontSize: 12,color: colorTextGrey);
}

TextStyle getBoldStyle(){
  return const TextStyle(fontWeight: FontWeight.bold);
}
TextStyle getW500Style(){
  return const TextStyle(fontWeight: FontWeight.w500);
}