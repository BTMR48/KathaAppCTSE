
class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? address;
  String? phoneNumber;

  UserModel({this.uid, this.email, this.firstName, this.secondName, this.address, this.phoneNumber});

  //receiving data from server
  factory UserModel.formMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      address: map['address'],
      phoneNumber:map['phoneNumber'],
    );
  }

  // sending data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'address':address,
      'phoneNumber':phoneNumber
    };
  }
}
