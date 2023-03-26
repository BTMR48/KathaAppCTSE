
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kathaappctse/screens/therapyNotes/viewAddedNotesAll.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      getNote(widget.id!);
    } 
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
        title: Text('Edit Note '),
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
                child: Text("Update"),
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