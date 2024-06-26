import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CommentEntity {
  final String id;
  final String title;
  final String content;
  final String date;
  final String username;

  CommentEntity.fromObject(ParseObject object)
      : id = object.get('objectId'),
        title = object.get('title'),
        content = object.get('content'),
        date = object.get('date'),
        username = object.get('username');
}
