import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:baraarujiyeapp/Screens/Hompage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;
Future<void> main() async {
  Hive.registerAdapter<Products>(ProductsAdapter());
  //initializing Hive
  await Hive.initFlutter();
  //our hive model class

  await Hive.openBox('date');
  await Hive.openBox('ispressed');
  await Hive.openBox('modeStatus');
  await Hive.openBox('Language');
  box = await Hive.openBox<Products>('products');
  // box.add(
  //     Products( 'Fanta', 'this is fanta from SPI', DateTime.now(), false));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          //primarySwatch: Colors.blue,
          ),
      home: AnimatedSplashScreen(
          splash: Container(
              child: Image.asset('lib/images/bararujiye logo name.png',height: 70,)),
          splashTransition: SplashTransition.fadeTransition,
          duration: 3000,
          backgroundColor: AppColors().fourthAppColor,
          nextScreen: HomePage()),
    );
  }
}
