import 'package:favorite_places/screens/places_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 102, 6, 247),
  surface: Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: colorScheme.surface,
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: colorScheme.surfaceContainer,
  ),
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
  ),
);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: PlacesListScreen());
  }
}
