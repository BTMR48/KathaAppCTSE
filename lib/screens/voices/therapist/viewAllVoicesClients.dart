import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kathaappctse/screens/voices/therapist/updateVoiceTest.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/config.dart';
import '../../login&signup&splashscreen/loginScreen.dart';
import 'VoiceUpdate.dart';

import 'oneVoiceScreen.dart';


class AllVoiceTherapistScreen extends StatefulWidget {
  const AllVoiceTherapistScreen({Key? key}) : super(key: key);

  @override
  State<AllVoiceTherapistScreen> createState() => _AllVoiceTherapistScreenState();
}

class _AllVoiceTherapistScreenState extends State<AllVoiceTherapistScreen> {
  List<Voice> tutorial = [];

  void _deleteTask(int index) {
    setState(() {
      tutorial.removeAt(index);
    });
  }

  // fetch data from collection
  @override
  Future<List<Voice>> fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('audio').get();
    return mapRecords(records);
  }

  List<Voice> mapRecords(QuerySnapshot<Object?>? records) {
    var _list = records?.docs
        .map(
          (voice) => Voice(
        id: voice.id,
            title: voice['title'],
        url: voice["url"],
      ),
    )
        .toList();

    return _list ?? [];
  }


  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  late VideoPlayerController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.grey[200],

        appBar: AppBar(
          backgroundColor: Colors.pink,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF545D68),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Audio management',
            style: TextStyle(
              fontFamily: 'Varela',
              fontSize: 24.0,
              color: const Color(0xFF545D68),
            ),
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.notifications_none,
            //     color: Color(0xFF545D68),
            //   ),
            //   onPressed: () {},
            // ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Config.app_background2), fit: BoxFit.fill),
          ),
          child: FutureBuilder<List<Voice>>(
              future: fetchRecords(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Voice>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Voice found.'));
                } else {
                  return Scrollbar(
                    isAlwaysShown: true,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewOneVoiceScreen(
                                      audioId: snapshot.data![index].id,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data![index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                        color: Colors.blueAccent
                                    ),
                                  ),
                                  SizedBox(height: 8),

                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  UpdateAudioRecorder()));
    },
    child: Icon(Icons.add),
    ),
    );
  }
}

