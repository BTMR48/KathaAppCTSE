import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:kathaappctse/screens/therapyNotes/viewAddedNotesAll.dart';

import 'package:kathaappctse/screens/voices/client/updateVoiceTest.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';

import '../../../utils/config.dart';
import '../voices/client/VoiceUpdate.dart';
import 'noteModel.dart';
import 'noteUpdateScreen.dart';



class ViewOneNoteUpdateScreen extends StatefulWidget {
  String noteID;
  ViewOneNoteUpdateScreen({Key? key,  required this.noteID}) : super(key: key);

  @override
  State<ViewOneNoteUpdateScreen> createState() => _ViewOneNoteUpdateScreenState();
}

class _ViewOneNoteUpdateScreenState extends State<ViewOneNoteUpdateScreen> {
  Note? oneNote;
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
    final id = widget.noteID;
    final reference = FirebaseFirestore.instance.doc('notes/$id');
    final snapshot = reference.get();

    final result = await snapshot.then(
            (snap) => snap.data() == null ? null : Note.fromJson(snap.data()!));
    print('result is ====> $result');
    setState(() {
      oneNote = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.id);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          'Notes',
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
                    oneNote!.title,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                    iconSize: 48,
                    color: Colors.greenAccent,
                    onPressed: _isPlaying ? stopPlayback : startPlayback,
                  ),
                  Text(
                    oneNote!.noteName,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('notes')
                              .doc(widget.noteID)
                              .delete().whenComplete(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllNotesAddedScreen(
                                      )
                              )
                          )
                          );
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
                                      NoteUpdateScreen( id : widget.noteID,)));
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
      if (oneNote!.voice.isNotEmpty) {
        await _player!.startPlayer(fromURI: _audioPath.isNotEmpty ? _audioPath :oneNote!.voice);
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
