import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './provider/weatherProvider.dart';
import 'screens/homeScreen.dart';
import 'screens/sevenDayForecastDetailScreen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'Flutter Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: seedBlue,
          scaffoldBackgroundColor: surfaceWhite,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: ink,
            elevation: 0,
            centerTitle: false,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedBlue,
            primary: seedBlue,
            secondary: skyBlue,
            surface: surfaceWhite,
            background: surfaceMuted,
            onPrimary: Colors.white,
            onSurface: ink,
          ),
          dividerTheme:
              const DividerThemeData(color: outlineSoft, thickness: 1),
          cardTheme: CardThemeData(
            color: surfaceWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          textTheme: GoogleFonts.manropeTextTheme().apply(bodyColor: ink),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          primaryColor: seedBlue,
          scaffoldBackgroundColor: const Color(0xFF0A1224),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedBlue,
            brightness: Brightness.dark,
            primary: seedBlue,
            secondary: skyBlue,
            surface: const Color(0xFF101B33),
            background: const Color(0xFF0A1224),
            onPrimary: Colors.white,
            onSurface: Colors.white,
          ),
          dividerTheme:
              const DividerThemeData(color: Color(0xFF203052), thickness: 1),
          cardTheme: CardThemeData(
            color: const Color(0xFF101B33),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          textTheme:
              GoogleFonts.manropeTextTheme().apply(bodyColor: Colors.white),
        ),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
        // routes: {
        //   WeeklyScreen.routeName: (ctx) => WeeklyScreen(),
        // },
        onGenerateRoute: (settings) {
          final arguments = settings.arguments;
          if (settings.name == SevenDayForecastDetail.routeName) {
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => SevenDayForecastDetail(
                initialIndex: arguments == null ? 0 : arguments as int,
              ),
              transitionsBuilder: (ctx, a, b, c) => CupertinoPageTransition(
                primaryRouteAnimation: a,
                secondaryRouteAnimation: b,
                linearTransition: false,
                child: c,
              ),
            );
          }
          // Unknown route
          return MaterialPageRoute(builder: (_) => HomeScreen());
        },
      ),
    );
  }
}
