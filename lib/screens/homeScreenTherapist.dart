import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/homeScreenUser.dart';
import 'package:kathaappctse/screens/login&signup&splashscreen/loginScreen.dart';
import 'package:kathaappctse/screens/therapy/client/viewAllTutorialClient.dart';
import 'package:kathaappctse/screens/therapy/therapist/addtutorials.dart';
import 'package:kathaappctse/screens/therapy/therapist/viewAllTutorials.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';

import 'therapyNotes/ViewAllNote.dart';
import 'therapyNotes/addNote.dart';
import 'therapyNotes/viewAddedNotesAll.dart';
import '../../../utils/config.dart';

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
        appBar: AppBar(
          actions: [

            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
            ),

          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Config.app_background2), fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: 300.0,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Color(0x80FFFFFF),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    // 'චිකිත්සක උපකරණ පුවරුව',
                    'Therapist Dashboard',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // Number of columns in the grid
                    mainAxisSpacing: 16.0, // Vertical spacing between items
                    crossAxisSpacing: 16.0, // Horizontal spacing between items
                    padding: EdgeInsets.all(16.0), // Padding around the grid
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AllVoiceClientScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple.shade400,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.record_voice_over, size: 60.0, color: Colors.white),
                            SizedBox(height: 16.0),
                            Text(
                              'Voices',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AllTutorialAdminScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal.shade400,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.healing, size: 60.0, color: Colors.white),
                            SizedBox(height: 16.0),
                            Text(
                              'Therapy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AllVoiceTherapyNoteScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink.shade400,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.notes, size: 60.0, color: Colors.white),
                            SizedBox(height: 16.0),
                            Text(
                              'Therapy notes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AllNotesAddedScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade400,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.note_add, size: 60.0, color: Colors.white),
                            SizedBox(height: 16.0),
                            Text(
                              'Notes list page',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
    );
  }
}
