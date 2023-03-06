
import 'package:flutter/material.dart';

import 'LoginScreen.dart';



Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp( MyApp());
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
      home:  const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
