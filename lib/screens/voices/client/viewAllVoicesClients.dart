import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kathaappctse/screens/voices/client/updateVoiceTest.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../login&signup&splashscreen/loginScreen.dart';
import 'VoiceUpdate.dart';
import 'addvoice.dart';
import 'oneVoiceScreen.dart';


class AllVoiceClientScreen extends StatefulWidget {
  const AllVoiceClientScreen({Key? key}) : super(key: key);

  @override
  State<AllVoiceClientScreen> createState() => _AllVoiceClientScreenState();
}

class _AllVoiceClientScreenState extends State<AllVoiceClientScreen> {
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
      appBar: AppBar(
        title: Text('Voice List'),
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
            stream: FirebaseFirestore.instance.collection('audio').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Voice> data = mapRecords(snapshot.data);
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
                                            data[index].title,
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
                                                            ViewOneVoiceScreen(
                                                              audioId: data[
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
                                                    .collection('audio')
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
                                                            UpdateAudioRecorder( audioId:  data[index].id,
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
                      UpdateAudioRecorder()));
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

