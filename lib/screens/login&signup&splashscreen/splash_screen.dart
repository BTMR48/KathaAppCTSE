import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'loginScreen.dart';
import 'nextscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //init state

  @override
  void initState() {

    super.initState();

    //create a timer of 2 seconds
    Timer(const Duration(seconds: 2), () {
      // if(finish == ){
      //
      // }

 nextScreen(context, const LoginScreen());

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 500,
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage(Config.app_background1), fit: BoxFit.fill),
      // ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 120, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const Image(
                    //   image: AssetImage(Config.app_logogif),
                    //   height: 256,
                    //   width: 254,
                    //   fit: BoxFit.cover,
                    // ),
                    const SizedBox(height: 54),
                    Text(
                      'සාදරයෙන් පිළිගනිමු',
                      style: TextStyle(
                        fontSize: 32,
                        color: HexColor('#357EB2'),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Katha App Wetha',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#346A9B'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
