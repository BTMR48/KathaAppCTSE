import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "කතා උපකාර පිටුව",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.blue,
                            decorationColor: Colors.redAccent,
                            // fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Image.asset(
                          'assets/images/logo.jpg',
                          width: 400,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                            child:Text("ආයුබෝවන්,\n\nකතා හි 'යෙදුම් භාවිතා කිරීම සඳහා ආරම්භක මාර්ගෝපදේශය' වෙත සාදරයෙන් පිළිගනිමු. මෙම මාර්ගෝපදේශය යෙදුම් සොයන ආකාරය, බාගත කර විවෘත කරන ආකාරය ඔබට පෙන්වයි.",
                                style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("දරුවාගේ කථනය පටිගත කරන්නේ කෙසේද?",
                                  style: TextStyle(color: Colors.redAccent)),

                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:Text("කතා පිටුවෙහි වම්පස පහළ කොටසේ ඇති මයික් සලකුණ මත ක්ලික් කරන්න.දරුවාට අදාල වචනය උච්චාරණය කිරීමට ඉඩ දෙන්න.",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("කථනය පටිගත කරන විට නොකල යුතු දෑ",
                                style: TextStyle(color: Colors.redAccent)),

                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:Text("දරුවාට අමතරව වෙනත් අය කතා නොකළ යුතුය.බාහිර පරිසරයේ වෙනත් ශබ්ද නොඇසිය යුතුය.",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                            child:Text("කථනය පටිගත කරන විට අවධානය යොමු කළ යුතු කරුණු",
                                style: TextStyle(color: Colors.redAccent)),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:Text("මයික්‍රෆෝනය දරුවාගේ මුවට සමීප කරන්න.ශබ්දනගා වචනය උච්චාරණය කිරීමට දරුවා උනන්දු කරවන්න.",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
