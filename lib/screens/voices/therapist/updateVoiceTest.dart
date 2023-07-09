import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../homeScreenUser.dart';

class UpdateAudioRecorder extends StatefulWidget {
  final String? audioId;

  UpdateAudioRecorder({this.audioId});

  @override
  _UpdateAudioRecorderState createState() => _UpdateAudioRecorderState();
}

class _UpdateAudioRecorderState extends State<UpdateAudioRecorder> {
  File? _file;
  bool _isRecording = false;
  String _audioPath = '';
  bool _isPlaying = false;
  bool _isUpdating = false;

  bool _isAdding = false;
  FlutterSoundPlayer? _player;
  TextEditingController _titleController = TextEditingController();
   final TextEditingController _voiceUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _player?.openAudioSession();

    if (widget.audioId != null) {
      _fetchAudioRecord(widget.audioId!);
      _isUpdating = true;
    }  else {
  _isAdding = true;
  }
  }





  Future<void> _fetchAudioRecord(String id) async {
    final reference = FirebaseFirestore.instance.doc('audio/$id');
    final snapshot = await reference.get();
    final result = snapshot.data() == null
        ? null
        : Voice.fromJson(snapshot.data()!);

    setState(() {
      _titleController.text = result?.title ?? '';
      _voiceUrlController.text = result?.url ?? '';


    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Add Audio',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Text(
            _isRecording ? 'Recording...' : 'Tap to record',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.mic),


            iconSize: 48,
            color: Colors.redAccent,
            onPressed: _isRecording ? stopRecording : startRecording,
          ),
          SizedBox(height: 16),

          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                iconSize: 48,
                color: Colors.greenAccent,
                onPressed: _isPlaying ? stopPlayback : startPlayback,
              ),
              SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isUpdating || _isAdding ? save : null,
                  child: Text(_isUpdating ? "Update" : "Add"),
                ),
              ),

            ],
          ),
          SizedBox(height: 16),

        ],
      ),
    );
  }
  Future<void> save() async {
    if (_isUpdating) {
      await update();
    } else if (_isAdding) {
      await addnewvoice();
    }
    Navigator.pop(context);
  }
  Future<void> startRecording() async {
    try {
      Record record = Record();
      if (await record.hasPermission()) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path + '/audio.mp3';
        await record.start(path: tempPath);
        setState(() {
          _isRecording = true;
          _audioPath = tempPath;
        });
      }
    } catch (e) {
      print(e);
    }
  }


  Future<void> stopRecording() async {
    try {
      Record record = Record();
      String? path = await record.stop();
      if (path != null) {
        setState(() {
          _isRecording = false;
          _audioPath = path;
        });// Call the upload method here
      }
    } catch (e) {
      print(e);
    }
  }



  Future<void> startPlayback() async {

    try {
      if (_audioPath.isNotEmpty || _voiceUrlController.text.isNotEmpty) {
        await _player!.startPlayer(fromURI: _audioPath.isNotEmpty ? _audioPath : _voiceUrlController.text);

        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopPlayback() async {
    await _player!.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }
  String? audioUrl;
  @override
  void dispose() {
    super.dispose();
    _player!.closeAudioSession();
  }

  Future<void> update() async {


    if (_audioPath != null) {
      final audioFile = File(_audioPath);

      // Get a reference to the Firebase Storage bucket
      final storage = FirebaseStorage.instance;
      final audioStorageRef = storage.ref().child(
          'audio/${DateTime.now().toIso8601String()}.mp3');

      // Upload the audio file to Firebase Storage
      final uploadTask = audioStorageRef.putFile(audioFile);
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the URL of the uploaded audio file
      audioUrl = await snapshot.ref.getDownloadURL(); // Assign audioUrl here
    }

    // Update the tutorial document in Firestore
    await FirebaseFirestore.instance
        .collection('audio')
        .doc(widget.audioId!)
        .update({
      'title': _titleController.text,
      'url': _voiceUrlController.text ?? audioUrl, // Use audioUrl here
    });
  }




















  Future<void> addnewvoice() async {
    if (_audioPath.isNotEmpty) {
      // Get a reference to the audio file
      final audioFile = File(_audioPath);

      // Get a reference to the Firebase Storage bucket
      final storage = FirebaseStorage.instance;
      final audioStorageRef = storage.ref().child(
          'audio/${DateTime.now().toIso8601String()}.mp3');

      // Upload the audio file to Firebase Storage
      final uploadTask = audioStorageRef.putFile(audioFile);
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the URL of the uploaded audio file
      final audioUrl = await snapshot.ref.getDownloadURL();

      // Save the audio URL and title to Firestore
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('audio').add({
        'url': audioUrl,
        'title': _titleController.text.trim(),
      });

      // Save the audio file locally
      Directory appDir = await getApplicationDocumentsDirectory();
      File localFile = File('${appDir.path}/audio_file.mp3');
      await audioFile.copy(localFile.path);

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio uploaded successfully.')));
      // Navigate to HomeScreen after successful upload
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print("not added voice");
    }
  }


}
