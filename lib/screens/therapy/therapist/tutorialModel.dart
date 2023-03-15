import 'dart:convert';

Tutorial TutorialFromJson(String str) => Tutorial.fromJson(json.decode(str));

String TutorialToJson(Tutorial data) => json.encode(data.toJson());
class Tutorial {
  Tutorial({
    required this.id,
    required this.topic,
    required this.description,
    required this.url

  });
  String id;
  String topic;
  String description;
  String url;


  factory Tutorial.fromJson(Map<String, dynamic> json) => Tutorial(
    id: json["id"] ?? "",
    topic: json["topic"] ?? "",
    url: json["url"]?? "",
      description: json["description"]?? ""
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "topic": topic,
    "url": url,
    'description' : description

  };
}
