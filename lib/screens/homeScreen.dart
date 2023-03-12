import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/therapist/addtutorials.dart';
import 'package:kathaappctse/screens/voices/client/addvoice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(onPressed:(){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AudioRecorder() ) ) ;},
                child: Text(
                "Voices",
              ),),
              ElevatedButton(onPressed:(){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddTutorials() ) ) ;},
                child: Text(
                    "Therapy Page"
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
