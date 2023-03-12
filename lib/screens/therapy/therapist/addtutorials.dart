
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kathaappctse/screens/homeScreen.dart';
import 'package:video_player/video_player.dart';

class AddTutorials extends StatefulWidget {
  // the user id to create a image folder for a particular user
  String? userId;
  AddTutorials({Key? key, this.userId}) : super(key: key);

  @override
  State<AddTutorials> createState() => _AddTutorialsState();
}

class _AddTutorialsState extends State<AddTutorials> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network('https://www.example.com/video.mp4');
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  // initialization code
  File? _file;
  final imagePicker = ImagePicker();
  String? downloadURL;

  //image picker
  Future videoPickerMethod() async {
    final pick = await imagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _file = File(pick.path);
      } else {
        showSnackBar("No file selected", Duration(milliseconds: 400));
      }
    });
  }

  //uploading the image , then getting the download url and then
  //adding that download url to our cloud fire store
  Future uploadVideo() async {
    final postID = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance.ref().child("tutorials").child(
        "post_$postID");

    await ref.putFile(_file!);
    downloadURL = await ref.getDownloadURL();

    await firebaseFirestore.collection("articles").doc().set({
      "topic": sampledata1.text,
      "description": sampledata2.text,
      "url": downloadURL,
      "type": "video"
    }).whenComplete(() =>
    {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen())),
      showSnackBar("Video uploaded successful", Duration(seconds: 2))
    });
  }

  TextEditingController sampledata1 = new TextEditingController();
  TextEditingController sampledata2 = new TextEditingController();

  //snackbar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Widget introButton() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ElevatedButton(
            onPressed: () {
              send();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                const EdgeInsets.all(15),
              ),
              backgroundColor:
              MaterialStateProperty.all(Colors.blueAccent.withOpacity(0.4)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(179, 27, 5, 84),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    Widget VideoPreview() {
      return Visibility(
        visible: _file != null,
        child: SizedBox(
          width: 100,
          height: 100,
          child: VideoPlayer(_videoPlayerController),
        ),
      );
    }



    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor('#00FFFF').withOpacity(0.4),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen()),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color.fromARGB(255, 12, 63, 112),
          ),
        ),
        title: Text(
            "Add Articles",
            style: TextStyle(color: Colors.white)
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage(Config.app_background),
          //       fit: BoxFit.fill,
          //     )),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  //for rounded rectange clip

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                      height: height * 0.8,
                      width: double.infinity,
                      child: Column(
                        children: [


                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: SizedBox(
                              width: width * 0.9,
                              child: TextField(
                                controller: sampledata1,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: 'Add Topic',
                                  hintText: 'New Topic',
                                  prefixIcon: Icon(Icons.favorite),
                                  suffixIcon: Icon(Icons.query_builder),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: width * 0.9,
                              child: TextField(
                                controller: sampledata2,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: 'Add Description',
                                  hintText: 'New Description',
                                  prefixIcon: Icon(Icons.favorite),
                                  suffixIcon: Icon(Icons.query_builder),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),


                          Container(
                            width: 100,
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(Icons.video_library),
                                onPressed: () async {
                                  await videoPickerMethod();
                                  if (_file != null) {
                                    _videoPlayerController = VideoPlayerController.file(_file!);
                                    _videoPlayerController.initialize().then((_) {
                                      setState(() {});
                                      _videoPlayerController.play();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          VideoPreview(),
                          SizedBox(
                            height: 100,
                          ),
                          introButton()

                    ]
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  send() async {
    if (_file != null) {
      await uploadVideo();
    } else {
      showSnackBar("No file selected", Duration(milliseconds: 400));
    }
  }
}