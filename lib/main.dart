import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tartibak/l10n.dart';
import 'package:tartibak/pages/start_page.dart';
import 'package:tartibak/viewmodels/locale_provider.dart';
import 'package:tartibak/viewmodels/puzzle_view_model.dart';
import 'package:tartibak/viewmodels/settings_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (context) => PuzzleViewModel(settings: context.read<SettingsViewModel>())),
      ],
      child: const PuzzleApp(),
    ),
  );
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final localeProvider = context.watch<LocaleProvider>();
    return MaterialApp(
      title: 'Puzzle Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: localeProvider.locale.languageCode == 'fa' ? 'IranSansNum' : 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        fontFamily: localeProvider.locale.languageCode == 'fa' ? 'IranSansNum' : 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      themeMode: settings.themeMode,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fa')],
      locale: localeProvider.locale,
      home: const StartPage(),
    );
  }
}
