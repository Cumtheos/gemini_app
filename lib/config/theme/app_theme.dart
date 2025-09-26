import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//color semilla
const seedColor = Color(0xFF1E1C36);

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  //obtener tema
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    listTileTheme: const ListTileThemeData(iconColor: seedColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1C36),
      surfaceTintColor: Colors.transparent,
    ),
  );

  //configurar el systemchrome para la barra de arriba se vea igual en ios y en android
  static setSystemUIOverlayStyle({required bool isDarkMode}) {
    final themeBrightness = isDarkMode ? Brightness.dark : Brightness.light;
    final transparent = Colors.transparent;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: themeBrightness,
        statusBarIconBrightness: themeBrightness,
        systemNavigationBarIconBrightness: themeBrightness,
        statusBarColor: transparent,
        systemNavigationBarColor: transparent,
      ),
    );
  }
}
