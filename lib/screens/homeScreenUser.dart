import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/client/viewAllTutorialClient.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';

import 'therapyNotes/ViewAllNote.dart';
import 'therapyNotes/addNote.dart';
import 'therapyNotes/viewAddedNotesAll.dart';
import '../../../utils/config.dart';


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
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Perform logout action
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Perform logout action
              },

            ),
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                // Perform logout action
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
                    'ආයුබෝවන්!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 100,
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
                              // 'Voices',
                              'හඬ',
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
                            builder: (context) => ViewAllTutorialClientClass(),
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
                              'ක්‍රීඩා',
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
