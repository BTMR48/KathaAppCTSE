import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';

import 'feature_buttons_view.dart';

class Recorder19Screen extends StatefulWidget {
  @override
  State<Recorder19Screen> createState() => _Recorder19ScreenState();
}

class _Recorder19ScreenState extends State<Recorder19Screen> {
  String? downloadURL;
  List<Reference> references = [];
  @override
  void initState() {
    super.initState();
    _onUploadComplete();
  }

  //snack bar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(

        ),
        child: SafeArea(
            child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100, right: 0),
                      child: Column(
                        children: [
                          Material(
                            color: HexColor('#FFFBFB').withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            child: SizedBox(
                              width: width * 0.94,
                              height: height * 0.50, //white box height
                              child: Column(
                                children: [
                                  Expanded(
                                    child: FeatureButtonsView19(
                                      onUploadComplete: _onUploadComplete,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "${sp.uid}",
                    //   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    // ),
                  ],
                ))),
      ),
    );
  }

  Future<void> _onUploadComplete() async {
    // final sp = context.read<SignInProvider>();
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebaseStorage
        .ref()
        .child("recordings19")
        .child("${"sp.uid"}/records")
        .list();
    setState(() {
      references = listResult.items;
    });
  }
}