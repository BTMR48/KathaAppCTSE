import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/config.dart';
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
    Timer(const Duration(seconds:3), () {
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
      width:400,
      decoration:  BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Config.app_gif1), fit: BoxFit.fill),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 120, bottom: 60),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'කතා',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#346A9B'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 5),
                         child: Image(
                          image: AssetImage(Config.article_logo),
                          height: 280,
                          width: 350,
                          fit: BoxFit.cover,
                      ),
                       ),
                      const SizedBox(height: 150),
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

              ],
            ),
          ),
        ),
      ),
    ));
  }
}
