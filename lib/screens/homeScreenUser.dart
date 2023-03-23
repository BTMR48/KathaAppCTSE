import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/client/viewAllTutorialClient.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';

import 'TherapyNote/ViewAllNote.dart';
import 'TherapyNote/addNote.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                      MaterialPageRoute(builder: (context) => ViewAllTutorialClientClass() ) ) ;},
                  child: Text(
                      "Therapy Page client"
                  ),),
                ElevatedButton(onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AllVoiceTherapyNoteScreen() ) ) ;},
                  child: Text(
                      "Therapy note page "
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
