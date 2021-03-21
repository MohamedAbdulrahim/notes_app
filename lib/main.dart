//بسم الله الرحمن الرحيم
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/pages/NewNote.dart';
import 'package:note_app/pages/home.dart';

import 'constants.dart';

void main() {
  int grey50Color = 0xFFFAFAFA;
  Map<int, Color> colors = {
    50: Color(grey50Color),
    100: Color(grey50Color),
    200: Color(grey50Color),
    300: Color(grey50Color),
    400: Color(grey50Color),
    500: Color(grey50Color),
    600: Color(grey50Color),
    700: Color(grey50Color),
    800: Color(grey50Color),
    900: Color(grey50Color),
  };

  MaterialColor colorNote = MaterialColor(grey50Color, colors);
  runApp(
    DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(Constants.redColor),
          unselectedItemColor: Color(Constants.redColor),
        ),
        accentColor: Color(Constants.redColor),
        cursorColor: Color(Constants.redColor),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 5,
                color: Color(Constants.redColor),
                style: BorderStyle.solid),
          ),
        ),
        hintColor: Color(Constants.redColor),
        appBarTheme: AppBarTheme(elevation: 0),
        iconTheme: IconThemeData(color: Colors.black),
        primarySwatch: colorNote,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            Home.route: (context) => Home(),
            NewNote.route: (context) => NewNote(Note.newNote(), true),
          },
        );
      },
    ),
  );
}
/*
changing app name sfrom manifest in Android,info in IOS
changing app icon manually
*/
