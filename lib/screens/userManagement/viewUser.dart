import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/login&signup&splashscreen/userModel.dart';
import 'package:kathaappctse/screens/userManagement/viewOneUser.dart';
import 'package:kathaappctse/screens/login&signup&splashscreen/loginScreen.dart';

class ViewAllUsersClass extends StatefulWidget {
  const ViewAllUsersClass({Key? key}) : super(key: key);

  @override
  State<ViewAllUsersClass> createState() =>
      _ViewAllUsersClassState();
}

class _ViewAllUsersClassState
    extends State<ViewAllUsersClass> {
  List<UserModel> user = [];

  // fetch data from collection
  @override
  Future<List<UserModel>> fetchUsers() async {
    var records =
    await FirebaseFirestore.instance.collection('users').get();
    return mapUsers(records);
  }

  List<UserModel> mapUsers(QuerySnapshot<Object?>? userRecords) {
    var _list = userRecords?.docs
        .map(
          (user) =>
              UserModel(
                uid: user.id,
                email: user['email'],
                firstName: user['firstName'],
                secondName: user['secondName'],
                address: user['address'],
                phoneNumber:user['phoneNumber']
          ),
    )
        .toList();
    return _list ?? [];
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
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
            'User',
              style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 24.0,
                color: const Color(0xFF545D68),
              ),
          ),
          actions: [],
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/background1.jpg',
              fit: BoxFit.cover,
              height: height,
              width: width,
        ),
        FutureBuilder<List<UserModel>>(
            future: fetchUsers(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No users found.'));
              } else {
                return Scrollbar(
                  isAlwaysShown: true,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewOneUser(
                                    id: snapshot.data![index].uid.toString(),
                                  ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data![index].uid.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].email.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].firstName.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].secondName.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  snapshot.data![index].phoneNumber.toString(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
        )
  ]));
  }
}

