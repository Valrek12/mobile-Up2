import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:up2_application_mobile/pages/root_pages/root_page.dart';
import 'package:up2_application_mobile/service/up2_provider.dart';
import 'package:up2_application_mobile/utils/color_page.dart';

void main() {
  runApp(new Up2App());
}

class Up2App extends StatelessWidget {
  // login page parameters:
  // primary swatch color
  final Color appColor = HexColor.fromHex('#242424');
  static const primarySwatch = Colors.orange;
  // button color
  static const buttonColor = Colors.orange;
  // app name
  static const appName = 'Up2';
  // boolean for showing home page if user unverified
  static const homePageUnverified = false;

  final params = {
    'appName': appName,
    'primarySwatch': primarySwatch,
    'buttonColor': buttonColor,
    'homePageUnverified': homePageUnverified,
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Up2',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: appColor),
          backgroundColor: Colors.white),
      home: new RootPage(params: params, auth: new Up2Provider()),
    );
  }
}
