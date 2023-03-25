
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kathaappctse/screens/therapyNotes/viewAddedNotesAll.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';
import 'package:video_player/video_player.dart';

import 'NoteModel.dart';
import 'ViewAllNote.dart';



class NoteUpdateScreen extends StatefulWidget {
  final String? id;

  const NoteUpdateScreen({Key? key, this.id}) : super(key: key);

  @override
  _NoteUpdateScreenState createState() => _NoteUpdateScreenState();
}

class _NoteUpdateScreenState extends State<NoteUpdateScreen> {
  final TextEditingController _noteNameController = TextEditingController();
  late VideoPlayerController _videoPlayerController;
  bool _isUpdating = false;
  bool _isAdding = false;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.network('https://www.example.com/video.mp4');
    super.initState();
    if (widget.id != null) {
      _isUpdating = true;
      getNote(widget.id!);
    } else {
      _isAdding = true;
    }
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

  //snackbar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> getNote(String id) async {
    final reference = FirebaseFirestore.instance.doc('notes/$id');
    final snapshot = await reference.get();
    final result = snapshot.data() == null
        ? null
        : Note.fromJson(snapshot.data()!);

    setState(() {
      _noteNameController.text = result?.noteName ?? '';


    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdding ? 'Edit Note' : 'Edit '),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _noteNameController,
                decoration: InputDecoration(
                  labelText: "Note",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:add,
                child: Text(_isUpdating ? "Update" : "Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> add() async {
    FirebaseFirestore.instance.collection('notes').doc(widget.id!).update({
      'noteName': _noteNameController.text,
    }).whenComplete(() =>  Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AllNotesAddedScreen()))
    );

  }


}