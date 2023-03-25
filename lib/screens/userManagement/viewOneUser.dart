import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:kathaappctse/screens/login&signup&splashscreen/userModel.dart';

import '../../../Navigation/bottomNavigation.dart';
import '../../../utils/config.dart';

class ViewOneUser extends StatefulWidget {
  const ViewOneUser({Key? key, required this.id}) : super(key: key);
  final String id;
  //
  @override
  _ViewOneUserState createState() => _ViewOneUserState();
}
class _ViewOneUserState extends State<ViewOneUser> {
  UserModel? oneUser;
  bool loading = false;
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final addressController = new TextEditingController();
  final phoneNumberController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    loading = true;
    // getArticle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }}