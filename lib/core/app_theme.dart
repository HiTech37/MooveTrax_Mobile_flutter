import 'package:moovetrax/core/app_string.dart';
import 'package:flutter/material.dart';
import 'package:moovetrax/core/app_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightAppTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightThemeColorList['scaffoldBackgroundColor'],
    appBarTheme: AppBarTheme(
      color: lightThemeColorList['appBarColor'],
      foregroundColor: lightThemeColorList['buttonTextColor'],
      centerTitle: true,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.white10,
          width: 1.0, // Change the width of the bottom border
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: lightThemeColorList['primaryTextColor']),
      bodyLarge: TextStyle(color: lightThemeColorList['primaryTextColor']),
      bodySmall: TextStyle(
          color: lightThemeColorList[
              'primaryTextColor']), // Change to any color you want
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Set the border radius here
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: lightThemeColorList['buttonTextColor'],
        type: BottomNavigationBarType.fixed,
        backgroundColor: lightThemeColorList['buttonBackgroundColor'],
        elevation: 0,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: const Color.fromARGB(255, 255, 229, 83)),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFF4511E), width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        filled: true,
        fillColor: const Color.fromARGB(255, 230, 224, 224)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: lightThemeColorList['buttonBackgroundColor'],
          foregroundColor: lightThemeColorList['buttonTextColor']),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green[600],
    ),
    fontFamily: AppString.appFont,
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    ),
  );

  static ThemeData darkAppTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: darkThemeColorList['appBarColor'],
      foregroundColor: darkThemeColorList['buttonTextColor'],
      centerTitle: true,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.white54,
          width: 0.2, // Change the width of the bottom border
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Set the border radius here
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.greenAccent,
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkThemeColorList['buttonBackgroundColor'],
        elevation: 0,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedItemColor: darkThemeColorList['primaryTextColor']),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: darkThemeColorList['primaryTextColor']),
      bodyLarge: TextStyle(color: darkThemeColorList['primaryTextColor']),
      bodySmall: TextStyle(
          color: darkThemeColorList[
              'primaryTextColor']), // Change to any color you want
    ),
    scaffoldBackgroundColor: darkThemeColorList['scaffoldBackgroundColor'],
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFF4511E), width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        filled: true,
        fillColor: const Color.fromRGBO(25, 30, 37, 1)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: darkThemeColorList['buttonBackgroundColor'],
          foregroundColor: darkThemeColorList['buttonTextColor']),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green[600],
    ),
    fontFamily: AppString.appFont,
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    ),
  );
}
