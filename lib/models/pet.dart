import 'package:flutter/foundation.dart';

class Pet {
  final String imageUrl;
  final String title;
  final String contentUrl;
  final DateTime dateAdded;

  Pet({
    @required this.imageUrl,
    @required this.title,
    @required this.contentUrl,
    @required this.dateAdded,
  });

  static Pet fromJson(dynamic json) {
    return Pet(
      imageUrl: json['image_url'],
      title: json['title'],
      contentUrl: json['content_url'],
      dateAdded: DateTime.parse(json['date_added']),
    );
  }
}
