import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';

class ViewOneVoiceScreen extends StatefulWidget {
  String audioId;
   ViewOneVoiceScreen({Key? key,  required this.audioId}) : super(key: key);

  @override
  State<ViewOneVoiceScreen> createState() => _ViewOneVoiceScreenState();
}

class _ViewOneVoiceScreenState extends State<ViewOneVoiceScreen> {
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
                  oneVoice!.title,
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
                IconButton(
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  iconSize: 48,
                  color: Colors.greenAccent,
                  onPressed: _isPlaying ? stopPlayback : startPlayback,
                ),
              ],
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
