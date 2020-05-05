import 'package:flutter/material.dart';

class TextPerso extends Text{

  TextPerso(String data, {texAlign: TextAlign.center, color: Colors.indigo, fontSize: 15.0, fontStyle: FontStyle.normal}):
      super(
          (data==null?"":data),
        textAlign: texAlign,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontStyle: fontStyle
        )
      );

}