
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/homeScreenUser.dart';
import 'package:kathaappctse/screens/login&signup&splashscreen/splash_screen.dart';
import '../screens/homeScreenUser.dart';
import '../screens/homeScreentherapist.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/login&signup&splashscreen/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'CTSE Lab Test',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),

          home: SplashScreen(),
          debugShowCheckedModeBanner: false,


    );
  }
}