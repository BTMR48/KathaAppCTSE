import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';

import '../../../utils/config.dart';
import '../homeScreenTherapist.dart';
import '../login&signup&splashscreen/userModel.dart';
import 'viewAllNote.dart';



class ViewNoteTherapyScreen extends StatefulWidget {
  String audioId;
  ViewNoteTherapyScreen({Key? key,  required this.audioId}) : super(key: key);

  @override
  State<ViewNoteTherapyScreen> createState() => _ViewNoteTherapyScreenState();
}

class _ViewNoteTherapyScreenState extends State<ViewNoteTherapyScreen> {
  Voice? oneVoice;
  bool loading = false;
  bool _isRecording = false;
  String _audioPath = '';
  bool _isPlaying = false;
  FlutterSoundPlayer? _player;


  @override
  initState() {
    super.initState();
    loading = true;
    _player = FlutterSoundPlayer();
    _player!.openAudioSession();
    getVoice();

  }

  Future<void> getVoice() async {
    final id = widget.audioId;
    final reference = FirebaseFirestore.instance.doc('audio/$id');
    final snapshot = reference.get();

    final result = await snapshot.then(
            (snap) => snap.data() == null ? null : Voice.fromJson(snap.data()!));
    print('result is ====> $result');
    setState(() {
      oneVoice = result;
      loading = false;
    });
  }

TextEditingController _noteController = TextEditingController();

@override
Widget build(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return Scaffold(
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
        'Note Management',
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
      child: loading ?
        CircularProgressIndicator()
          :
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    oneVoice!.title,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                    iconSize: 72,
                    color: Colors.green,
                    onPressed: _isPlaying ? stopPlayback : startPlayback,
                  ),
                  SizedBox(height: 50,),
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: 'Type notes here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.save),
                        label: Text('Save Notes'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent,
                          onPrimary: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance.collection("notes").doc().set({
                            'title': oneVoice!.title,
                            'voice': oneVoice!.url,
                            'noteName': _noteController.text,
                          }).whenComplete(() => Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (context) => AllVoiceTherapyNoteScreen()))
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> startPlayback() async {
    try {
      if (oneVoice!.url.isNotEmpty) {
        await _player!.startPlayer(fromURI: _audioPath.isNotEmpty ? _audioPath :oneVoice!.url);
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

void displayMessage() {

}

