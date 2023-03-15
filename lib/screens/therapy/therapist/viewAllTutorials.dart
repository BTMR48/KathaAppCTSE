import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/therapist/tutorialModel.dart';
import 'package:kathaappctse/screens/therapy/therapist/viewOneTutorial.dart';

import '../../login&signup&splashscreen/loginScreen.dart';
import 'ViewOneTutorialUpdate.dart';
import 'addtutorials.dart';

class AllTutorialAdminScreen extends StatefulWidget {
  const AllTutorialAdminScreen({Key? key}) : super(key: key);

  @override
  State<AllTutorialAdminScreen> createState() => _AllTutorialAdminScreenState();
}

class _AllTutorialAdminScreenState extends State<AllTutorialAdminScreen> {
  List<Tutorial> tutorial = [];

  void _deleteTask(int index) {
    setState(() {
      tutorial.removeAt(index);
    });
  }

  // fetch data from collection
  @override
  Future<List<Tutorial>> fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('tutorials').get();
    return mapRecords(records);
  }

  List<Tutorial> mapRecords(QuerySnapshot<Object?>? records) {
    var _list = records?.docs
        .map(
          (tutorial) => Tutorial(
        id: tutorial.id,
        topic: tutorial['topic'],
        description: tutorial["description"],
        url: tutorial["url"],
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
      appBar: AppBar(
        title: Text('Tutorial List'),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: SizedBox(
          width: width * 1,
          height: height * 1,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('tutorials').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Tutorial> data = mapRecords(snapshot.data);
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.20,
                      child: Card(
                        color: Colors.blue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 1),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data[index].topic,
                                            style: const TextStyle(color: Colors.black,fontSize: 30),
                                          ),
                                        ],
                                      ),


                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 20),
                                      //   child: _controller.value.isInitialized
                                      //           ? AspectRatio(
                                      //         aspectRatio: _controller.value.aspectRatio,
                                      //         child: VideoPlayer(_controller),
                                      //       )
                                      //           : Container(),
                                      //
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:120,top: 10),
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              child: Text('View'),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewOneTutorialScreen(
                                                              id: data[
                                                              index]
                                                                  .id,
                                                            )));
                                              },
                                            ),
                                            SizedBox(
                                              width:  5,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('tutorials')
                                                    .doc(data[index].id)
                                                    .delete();
                                              },
                                              child: Text("Delete"),
                                              style: ButtonStyle(
                                                textStyle: MaterialStateProperty.all(
                                                  const TextStyle(fontSize: 12),
                                                ),
                                                backgroundColor: MaterialStateProperty.all(
                                                  Colors.red,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:  5,
                                            ),
                                            ElevatedButton(
                                              child: Text('Edit'),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TutorialUpdateScreen( id:  data[index].id,
                                                            )));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),

        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        TutorialUpdateScreen()));
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

