import 'package:flutter/material.dart';
import 'src/views/widgets/navigation.dart';

void main() {
  runApp(MaterialApp(
    title: 'ESIEA Book App',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.brown[50],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.brown[900]),
        bodyMedium: TextStyle(color: Colors.brown[900]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.brown,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.brown,
        textTheme: ButtonTextTheme
            .primary,
      ),
    ),
    home: Navigation(),
  ));
}
