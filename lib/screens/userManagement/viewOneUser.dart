import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kathaappctse/screens/login&signup&splashscreen/userModel.dart';

class ViewOneUser extends StatefulWidget {
  final String id;
  const ViewOneUser({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewOneUser> createState() => _ViewOneUserState();
}

class _ViewOneUserState extends State<ViewOneUser> {
  late Future<UserModel> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<UserModel> fetchUser() async {
    var record =
    await FirebaseFirestore.instance.collection('users').doc(widget.id).get();
    return UserModel(
      uid: record.id,
      email: record['email'],
      firstName: record['firstName'],
      secondName: record['secondName'],
      address: record['address'],
      phoneNumber: record['phoneNumber'],
    );
  }

  void deleteUser(String uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).delete();
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
      ),
      body: Center(
        child: FutureBuilder<UserModel>(
          future: futureUser,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 5,
                  color: Colors.orange[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'UID: ${snapshot.data!.uid}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Email: ${snapshot.data!.email}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'First Name: ${snapshot.data!.firstName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Second Name: ${snapshot.data!.secondName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Address: ${snapshot.data!.address}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Phone Number: ${snapshot.data!.phoneNumber}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                                deleteUser(
                                  snapshot.data!.uid.toString(),
                                );
                            },
                            child: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewOneUser(
                                    id: widget.id,
                                  ),
                                ),
                              );
                            },
                            child: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
