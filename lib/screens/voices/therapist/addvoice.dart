
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../homeScreenUser.dart';

class AudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  String _audioPath = '';
  bool _isPlaying = false;
  FlutterSoundPlayer? _player;
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _player!.openAudioSession();
  }

  Future<void> uploadAudioToFirebaseStorage() async {
    if (_audioPath.isNotEmpty) {
      // Get a reference to the audio file
      final audioFile = File(_audioPath);

      // Get a reference to the Firebase Storage bucket
      final storage = FirebaseStorage.instance;
      final audioStorageRef = storage.ref().child('audio/${DateTime.now().toIso8601String()}.mp3');

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

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio uploaded successfully.')));
      // Navigate to HomeScreen after successful upload
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

    }else{
      print("not added voice");
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Sub Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 100,),
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
          // Text(
          //   'Recorded audio path:',
          //   style: TextStyle(fontSize: 16),
          // ),
          // SizedBox(height: 8),
          // Text(
          //   _audioPath,
          //   style: TextStyle(fontSize: 14),
          // ),
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
              ElevatedButton(
                child: Text('Upload'),
                onPressed: _audioPath.isNotEmpty ? () => uploadAudioToFirebaseStorage() : null,
              ),
            ],
          ),
          SizedBox(height: 16),

        ],
      ),
    );
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
      if (_audioPath.isNotEmpty) {
        await _player!.startPlayer(fromURI: _audioPath);
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

  @override
  void dispose() {
    super.dispose();
    _player!.closeAudioSession();
  }
}
