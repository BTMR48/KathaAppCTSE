import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/therapist/tutorialModel.dart';
import 'package:kathaappctse/screens/therapy/therapist/viewOneTutorial.dart';

import '../../login&signup&splashscreen/loginScreen.dart';

class ViewAllTutorialClientClass extends StatefulWidget {
  const ViewAllTutorialClientClass({Key? key}) : super(key: key);

  @override
  State<ViewAllTutorialClientClass> createState() =>
      _ViewAllTutorialClientClassState();
}

class _ViewAllTutorialClientClassState
    extends State<ViewAllTutorialClientClass> {
  List<Tutorial> tutorial = [];

  // fetch data from collection
  @override
  Future<List<Tutorial>> fetchRecords() async {
    var records =
    await FirebaseFirestore.instance.collection('tutorials').get();
    return mapRecords(records);
  }

  List<Tutorial> mapRecords(QuerySnapshot<Object?>? records) {
    var _list = records?.docs
        .map(
          (tutorial) =>
          Tutorial(
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
        backgroundColor: Colors.grey[200],

        appBar: AppBar(
          backgroundColor: Colors.white,
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
            'Tutorial',
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
        body: FutureBuilder<List<Tutorial>>(
            future: fetchRecords(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Tutorial>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No tutorials found.'));
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
                                  ViewOneTutorialScreen(
                                    id: snapshot.data![index].id,
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
                                  snapshot.data![index].topic,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  snapshot.data![index].description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
        )
    );
  }
}

