import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../recorder/recoder.dart';

class AddVoiceRecorderScreen extends StatefulWidget {
  const AddVoiceRecorderScreen({Key? key}) : super(key: key);

  @override
  State<AddVoiceRecorderScreen> createState() => _AddVoiceRecorderScreenState();
}

class _AddVoiceRecorderScreenState extends State<AddVoiceRecorderScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
      // do something when the button is pressed
      Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Recorder19Screen()),
    );
    // RecorderDialogScreen(context);
  },
              child: Text("voice"))
        ],
      ),

    );
  }
}
