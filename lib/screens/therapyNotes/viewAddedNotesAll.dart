import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kathaappctse/screens/voices/client/voicesModel.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/config.dart';
import '../homeScreenTherapist.dart';
import '../homeScreenUser.dart';
import '../login&signup&splashscreen/loginScreen.dart';
import 'noteModel.dart';
import 'viewOneNote.dart';



class AllNotesAddedScreen extends StatefulWidget {
  const AllNotesAddedScreen({Key? key}) : super(key: key);

  @override
  State<AllNotesAddedScreen> createState() => _AllNotesAddedScreenState();
}

class _AllNotesAddedScreenState extends State<AllNotesAddedScreen> {
  List<Note> notes = [];

  void _deleteTask(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  // fetch data from collection
  @override
  Future<List<Note>> fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('notes').get();
    return mapRecords(records);
  }

  List<Note> mapRecords(QuerySnapshot<Object?> records) {
    var _list = records.docs
        .map(
          (notes) => Note(

        id: notes.id,
        // uid: notes['uid'],
        title: notes['title'],
        voice: notes["voice"],
            noteName: notes["noteName"],
      ),
    )
        .toList();

    return _list ;
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
          'All Notes',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 24.0,
            color: const Color(0xFF545D68),
          ),
        ),
        actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreenTherapist(),
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
        child: FutureBuilder<List<Note>>(
            future: fetchRecords(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Note>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No Note found.'));
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
                                  ViewOneNoteUpdateScreen(
                                    noteID: snapshot.data![index].id,
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


    );
  }
}

