import 'dart:convert';

Note NoteFromJson(String str) => Note.fromJson(json.decode(str));

String NoteToJson(Note data) => json.encode(data.toJson());
class Note {
  Note({

    required this.id,
    required this.uid,
    required this.title,
    required this.voice,
    required this.noteName

  });
  String uid;
  String id;
  String title;
  String voice;
  String noteName;


  factory Note.fromJson(Map<String, dynamic> json) => Note(

    uid: json["uid"] ?? "",
      id: json["id"] ?? "",
      title: json["title"] ?? "",
    voice: json["voice"]?? "",
    noteName: json["noteName"]?? "",

  );

  Map<String, dynamic> toJson() => {
    "uid" :uid,
    "id": id,
    "title": title,
    "voice": voice,
    "noteName": noteName,
    
  };
}
