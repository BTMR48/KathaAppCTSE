import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/therapy/therapist/tutorialModel.dart';

class ViewOneTutorialScreen extends StatefulWidget {
  const ViewOneTutorialScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<ViewOneTutorialScreen> createState() => _ViewOneTutorialScreenState();
}

class _ViewOneTutorialScreenState extends State<ViewOneTutorialScreen> {
  Tutorial? oneTutorial;
  bool loading = false;

  @override
  initState() {
    super.initState();
    loading = true;
    getArticle();
  }

  Future<void> getArticle() async {
    final id = widget.id;
    final reference = FirebaseFirestore.instance.doc('tutorials/$id');
    final snapshot = reference.get();

    final result = await snapshot.then(
            (snap) => snap.data() == null ? null : Tutorial.fromJson(snap.data()!));
    print('result is ====> $result');
    setState(() {
      oneTutorial = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.id);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage(Config.app_background), fit: BoxFit.fill),
        // ),
        ),
        child: loading ?
        CircularProgressIndicator()
            :
            Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  oneTutorial!.topic,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                    decorationColor: Colors.redAccent,
                    // fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Image.network(
                  oneTutorial!.url,
                  height: 350,
                  width: width * 0.8,
                ),
                SizedBox(
                  height: 100,
                  width: 300,
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(oneTutorial!.description,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//
}
