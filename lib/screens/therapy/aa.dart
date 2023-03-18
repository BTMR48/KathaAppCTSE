import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kathaappctse/screens/therapy/therapist/tutorialModel.dart';
import 'package:video_player/video_player.dart';

import '../../../Navigation/bottomNavigation.dart';



class ViewOneTutorialScreen extends StatefulWidget {
  const ViewOneTutorialScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _ViewOneTutorialScreenState createState() => _ViewOneTutorialScreenState();
}

class _ViewOneTutorialScreenState extends State<ViewOneTutorialScreen> {
  Tutorial? oneTutorial;
  bool loading = false;
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    loading = true;
    getArticle();

  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  Future<void> getArticle() async {
    final id = widget.id;
    final reference = FirebaseFirestore.instance.doc('tutorials/$id');
    final snapshot = reference.get();

    final result = await snapshot.then((snap) =>
    snap.data() == null ? null : Tutorial.fromJson(snap.data()!));
    print('result is ====> $result');
    setState(() {
      oneTutorial = result;
      loading = false;
      videoPlayerController =
          VideoPlayerController.network(oneTutorial!.url);
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        allowMuting: true,
        allowPlaybackSpeedChanging: false,
        showControls: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
          'Tutorial',
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
          //   image: DecorationImage(
          //       image: AssetImage(Config.app_background), fit: BoxFit.fill),
          // ),
        ),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
          child: SingleChildScrollView(
            child: Padding(

              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.3,
                    width: width * 1,
                    child: Stack(
                      children: [
                        Chewie(controller: chewieController),
                        Container(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 26.0),
                  Center(
                    child: Text(
                      oneTutorial!.topic,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Varela',
                        fontSize: 32.0,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 52.0,
                      child: Text(
                        oneTutorial!.description,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 16.0,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),


                ],
              ),
            ),
          ),

        ),
      ),

    );
  }
}
