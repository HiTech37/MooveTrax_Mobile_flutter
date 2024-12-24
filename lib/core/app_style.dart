import 'package:flutter/material.dart';

const darkThemeColorList = {
  'primaryTextColor': Color.fromARGB(255, 172, 172, 172),
  'appBarColor': Color.fromRGBO(21, 25, 29, 1),
  'buttonBackgroundColor': Color.fromRGBO(33, 38, 45, 1),
  'scaffoldBackgroundColor': Color.fromRGBO(0, 4, 9, 1),
  'buttonTextColor': Color.fromARGB(255, 172, 172, 172),
  'linkTextColor': Color.fromARGB(255, 148, 155, 179)
};
const lightThemeColorList = {
  'primaryTextColor': Color.fromARGB(255, 31, 31, 31),
  'appBarColor': Color.fromARGB(255, 53, 133, 57),
  'buttonBackgroundColor': Color.fromARGB(255, 53, 133, 57),
  'scaffoldBackgroundColor': Color.fromRGBO(250, 250, 250, 1),
  'buttonTextColor': Color.fromARGB(255, 245, 245, 245),
  'linkTextColor': Color.fromARGB(255, 53, 133, 57)
};

const headLine6 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.grey,
  overflow: TextOverflow.ellipsis,
);

const headLine5 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

const headLine4 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  overflow: TextOverflow.ellipsis,
);

const headLine3 = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w700,
  overflow: TextOverflow.ellipsis,
);

const headLine2 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.ellipsis,
);

const headLine1 = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);

const focusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black54, width: 2.0),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const errorBorder = OutlineInputBorder(
  borderSide: BorderSide(width: 3, color: Colors.redAccent),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

const inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.redAccent),
);

const focusedErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(width: 3, color: Colors.redAccent),
  borderRadius: BorderRadius.all(
    Radius.circular(10.0),
  ),
);
