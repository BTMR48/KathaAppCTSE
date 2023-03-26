import 'dart:convert';

Voice VoiceFromJson(String str) => Voice.fromJson(json.decode(str));

String VoiceToJson(Voice data) => json.encode(data.toJson());
class Voice {
  Voice({
    required this.uid,
    required this.id,
    required this.title,
    required this.url

  });
  String uid;
  String id;
  String title;
  String url;


  factory Voice.fromJson(Map<String, dynamic> json) => Voice(

    uid: json["uid"] ?? "",
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      url: json["url"]?? "",

  );

  Map<String, dynamic> toJson() => {
    "uid" :uid,
    "id": id,
    "title": title,
    "url": url,
    
  };
}
