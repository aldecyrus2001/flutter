import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/admin/admin_entry_point.dart';
import 'package:voting_system/admin/screen/adminDashboard.dart';
import 'package:voting_system/admin/screen/rating.dart';
import 'package:voting_system/admin/screen/settings.dart';
import 'package:voting_system/login/login.dart';
import 'package:voting_system/user/components/Bottom_Sheets/application_form.dart';
import 'package:voting_system/user/screen/userDashboard.dart';
import 'package:voting_system/user/user_entry_point.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF17203A),
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      home: const LoginScreen(),
      // home: UserEntryPoint(initialScreen: userHomeScreen()),

    );
  }
}

const defaultInputBorder = OutlineInputBorder (
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1
  )
);
