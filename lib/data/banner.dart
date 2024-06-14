import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class BannerEntity {
  final String id;
  final String imageUrl;
  BannerEntity(this.id, this.imageUrl);
  BannerEntity.fromObject(ParseObject json)
      : id = json['id'],
        imageUrl = json['image'];
}
