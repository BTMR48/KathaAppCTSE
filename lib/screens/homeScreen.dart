import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/therapist/addtutorials.dart';
import 'package:kathaappctse/screens/therapy/therapist/viewAllTutorials.dart';
import 'package:kathaappctse/screens/voices/client/addvoice.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';

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
                    MaterialPageRoute(builder: (context) => AllVoiceClientScreen() ) ) ;},
                child: Text(
                "Voices",
              ),),
              ElevatedButton(onPressed:(){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AllTutorialAdminScreen() ) ) ;},
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
