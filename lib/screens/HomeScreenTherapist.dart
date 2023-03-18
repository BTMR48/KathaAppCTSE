import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/client/viewAllTutorialClient.dart';
import 'package:kathaappctse/screens/therapy/therapist/addtutorials.dart';
import 'package:kathaappctse/screens/therapy/therapist/viewAllTutorials.dart';
import 'package:kathaappctse/screens/voices/client/addvoice.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';

class HomeScreenTherapist extends StatefulWidget {
  const HomeScreenTherapist({Key? key}) : super(key: key);

  @override
  State<HomeScreenTherapist> createState() => _HomeScreenTherapistState();
}

class _HomeScreenTherapistState extends State<HomeScreenTherapist> {
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
                      MaterialPageRoute(builder: (context) => AllTutorialAdminScreen() ) ) ;},
                  child: Text(
                      "Therapy Page"
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
