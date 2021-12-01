import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigations/router.gr.dart' as r;
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor:
        Colors.greenAccent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final r.AppRouter _appRouter = r.AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      routerDelegate: _appRouter.delegate(initialRoutes: [r.HomeViewRoute()], ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      title: 'Firebase CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.white,
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.blue,
        accentColorBrightness: Brightness.dark,
        bottomAppBarColor: Colors.white,
        buttonColor: Colors.blue,
        errorColor: Colors.red,
        buttonTheme: ButtonThemeData(
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.blue,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Color(0xffD4D4D4),
            ),
          ),
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'OpenSansRegular',
            color: Colors.grey,
          ),
        ),
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          elevation: 10,
          actionsIconTheme: IconThemeData(
            color: Colors.blue,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.blue,
          unselectedLabelColor: Color(0xff818181),
          labelStyle: TextStyle(
            fontSize: 22,
            fontFamily: 'OpenSansBold',
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 22,
            fontFamily: 'OpenSansBold',
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 30, // 75
            fontFamily: 'OpenSansSemibold',
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontSize: 22, // 50
            color: Colors.blue,
            fontFamily: 'OpenSansSemibold',
          ),
          headline3: TextStyle(
            fontSize: 22, // 50
            color: Colors.blue,
            fontFamily: 'OpenSansBold',
          ),
          headline4: TextStyle(
            fontSize: 22, // 50
            fontFamily: 'OpenSansLight',
          ),
          headline5: TextStyle(
            fontSize: 20, // 45
            fontFamily: 'OpenSansLight',
          ),
          headline6: TextStyle(
              fontSize: 18, // 40
              fontFamily: 'OpenSansLight',
              color: Colors.black),
          bodyText1: TextStyle(
            fontSize: 14, // 35
            fontFamily: 'OpenSansRegular',
            color: Colors.grey,
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontFamily: 'OpenSansLight',
            color: Colors.grey,
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            fontFamily: 'OpenSansRegular',
            letterSpacing: 0.15,
          ),
          subtitle2: TextStyle(
            fontSize: 14,
            fontFamily: 'OpenSansLight',
            letterSpacing: 0.1,
          ),
          overline: TextStyle(
              fontSize: 13,
              fontFamily: 'OpenSansLight',
              letterSpacing: 0.1,
              color: Colors.grey),
          button: TextStyle(
            fontSize: 22,
            fontFamily: 'OpenSansSemibold',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
