
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kathaappctse/screens/voices/client/viewAllVoicesClients.dart';
import 'package:kathaappctse/screens/voices/client/voicesModel.dart';
import 'package:video_player/video_player.dart';



class VoiceUpdateScreen extends StatefulWidget {
  final String? id;

  const VoiceUpdateScreen({Key? key, this.id}) : super(key: key);

  @override
  _VoiceUpdateScreenState createState() => _VoiceUpdateScreenState();
}

class _VoiceUpdateScreenState extends State<VoiceUpdateScreen> {
  final TextEditingController _voiceTitleController =
  TextEditingController();
  final TextEditingController _voiceUrlController = TextEditingController();
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
      getVoice(widget.id!);
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

  Future<void> getVoice(String id) async {
    final reference = FirebaseFirestore.instance.doc('audio/$id');
    final snapshot = await reference.get();
    final result = snapshot.data() == null
        ? null
        : Voice.fromJson(snapshot.data()!);

    setState(() {
      _voiceTitleController.text = result?.title ?? '';

      _voiceUrlController.text = result?.url ?? '';
      if (result?.url != null) {
        _videoPlayerController =
            VideoPlayerController.network(result!.url!);
        _videoPlayerController.initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdding ? 'Add Voice' : 'Edit Voice'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _voiceTitleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
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
                      _videoPlayerController =
                          VideoPlayerController.file(_file!);
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _isUpdating || _isAdding ? save : null,
                child: Text(_isUpdating ? "Update" : "Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget VideoPreview() {
    return Visibility(
      visible: _file != null || _voiceUrlController.text.isNotEmpty,
      child: SizedBox(
        width: 100,
        height: 100,
        child: _videoPlayerController.value.isInitialized
            ? VideoPlayer(_videoPlayerController)
            : Container(),
      ),
    );
  }


  Future<void> save() async {
    if (_isUpdating) {
      await update();
    } else if (_isAdding) {
      await add();
    }

  }

  Future<void> add() async {
    final postID = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance.ref().child("audio").child(
        "post_$postID");

    await ref.putFile(_file!);
    downloadURL = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('audio').add({
      'title': _voiceTitleController.text,
      'url': downloadURL,
    }).whenComplete(() =>  Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AllVoiceClientScreen())));
  }

  Future<void> update() async {
    if (_file != null) {
      // Upload the new video file to Firebase Storage
      final postID = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("audio")
          .child("post_$postID");
      await ref.putFile(_file!);
      downloadURL = await ref.getDownloadURL();
    }

    // Update the tutorial document in Firestore
    await FirebaseFirestore.instance
        .collection('audio')
        .doc(widget.id!)
        .update({
      'title': _voiceTitleController.text,
      'url': downloadURL ?? _voiceUrlController.text,
    }).whenComplete(() =>  Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AllVoiceClientScreen())));
  }
}