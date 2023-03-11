import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';




class FeatureButtonsView19 extends StatefulWidget {
  final Function onUploadComplete;

  FeatureButtonsView19({
    Key? key,
    required this.onUploadComplete,
  }) : super(key: key);

  @override
  _FeatureButtonsView19State createState() => _FeatureButtonsView19State();

  String? userId;
}

class _FeatureButtonsView19State extends State<FeatureButtonsView19> {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

   bool? _isPlaying;
   bool? _isUploading;
   bool? _isRecorded;
   bool? _isRecording;

   late AudioPlayer _audioPlayer;
    late String _filePath;

  late FlutterAudioRecorder2 _audioRecorder;

  Future getData() async {


  }

  String downloadUrl = '';

  Future<void> onsend() async {
    //uploading to cloudfirestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("recordings19")
        .doc()
        .set({'downloadURL': downloadUrl}).whenComplete(() =>
        showSnackBar("Voice uploaded successful", Duration(seconds: 2)));
  }

  //snackbar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
  }

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
    FirebaseFirestore.instance
        .collection("users")
        .doc()
        .get()
        .then((value) {
      setState(() {});
    });
  }

  // "නව වචන ඇතුලත් කරන්න",
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 100, right: 8),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "නව වචන ඇතුලත් කරන්න",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                icon: new Icon(Icons.close),
                color: Colors.redAccent,
                iconSize: 35,
                highlightColor: Colors.pink,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Center(
          child: _isRecorded!
              ? _isUploading!
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator()),
              Text('Uploading to Firebase'),
            ],
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: GestureDetector(
                 // onTap: _onPlayButtonPressed,
                  child: Center(
                    child: _isPlaying!
                        ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'assets/pause.png',
                            height: 140.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 0),
                          child: Center(
                            child: Image(
                              image: AssetImage(
                                  'assets/sound.gif'),
                              height: 50,
                              width: 550,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.only(top: 10),
                        //   child: Center(
                        //     child: Text(
                        //       "නැවත්වීමට ඉහත බොත්තම ඔබන්න",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w700),
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                        : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'assets/play.png',
                            height: 140.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 65,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110.0,
                      height: 30.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0),
                              side: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        onPressed: _onRecordAgainButtonPressed,
                        child: const Text(
                          'ආපසු',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 110.0,
                        height: 30.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(
                                Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18.0),
                                side: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          onPressed: _onFileUploadButtonPressed,
                          child: const Text(
                            "ඇතුලත් කරන්න",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
              : GestureDetector(
            onTap: _onRecordButtonPressed,
            child: Center(
              child: _isRecording!
                  ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/mic2.png',
                      height: 140.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 15, bottom: 15),
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/sound.gif'),
                        height: 50,
                        width: 550,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        "නැවත්වීමට ඉහත බොත්තම ඔබන්න",
                        style:
                        TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              )
                  : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/mic2.png',
                      height: 140.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        "Mic බොත්තම ඔබන්න",
                        style:
                        TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    setState(() {
      _isUploading = true;
    });
    try {

      Reference ref = firebaseStorage.ref().child('${"sp.uid"}/records1').child(
          _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length));
      TaskSnapshot uploadedFile = await ref.putFile(File(_filePath));

      if (uploadedFile.state == TaskState.success) {
        downloadUrl = await ref.getDownloadURL();
      }
      widget.onUploadComplete();
      onsend(); //send downloadURL after get it
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording!) {
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }
// error
//    Future<void> _onPlayButtonPressed() async {
//      if (_isPlaying!) {
//        _isPlaying = true;
//
//        await _audioPlayer.play(_current?.path , isLocal: true);
//        _audioPlayer.onPlayerCompletion.listen((duration) {
//          setState(() {
//            _isPlaying = false;
//          });
//        });
//      } else {
//        _audioPlayer.pause();
//        _isPlaying = false;
//      }
//      setState(() {});
//    }
 /// error
  Future<void> _startRecording() async {
    final bool? hasRecordingPermission =
    await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
  }
}