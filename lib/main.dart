import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:nike2/common/api_keys.dart';
import 'package:nike2/data/rep/auth_repository.dart';
import 'package:nike2/theme.dart';
import 'ui/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  // initialize bindings to take thme to parse initializer
  await Parse().initialize(
    ApiKeys.applicationId,
    ApiKeys.parseServerUrl,
    clientKey: ApiKeys.clientKey,
    autoSendSessionId: true,
    debug: true,
  );
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        fontFamily: 'BYekan', color: LightThemeColor.primaryTextColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: LightThemeColor.secondaryTextColor,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: LightThemeColor.primaryTextColor,
            elevation: 0),
        hintColor: LightThemeColor.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: LightThemeColor.primaryTextColor.withOpacity(0.1)))),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        textTheme: TextTheme(
            titleMedium: defaultTextStyle.apply(
                color: LightThemeColor.secondaryTextColor),
            bodyMedium: defaultTextStyle,
            labelLarge: defaultTextStyle,
            bodySmall: defaultTextStyle.apply(
                color: LightThemeColor.secondaryTextColor),
            titleLarge: defaultTextStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 18)),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColor.primaryColor,
            secondary: LightThemeColor.secondaryColor,
            onSecondary: Colors.white,
            surfaceVariant: Color(0xffF5F5F5)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
