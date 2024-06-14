import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;
  static const List<String> names = [
    'جدیدترین',
    'پربازدید ترین',
    'قیمت نزولی',
    'قیمت صعودی',
  ];
}

class ProductEntity {
  final String id;
  final String title;
  final String imageUrl;
  final int price;
  final String details;
  final int discount;
  final int previousPrice;

  ProductEntity.fromObject(ParseObject object)
      : id = object.get('objectId'),
        title = object.get('title'),
        imageUrl = object.get('imageUrl'),
        previousPrice = object.get('price'),
        price = object.get('price') -
            object.get('price') * (object.get('discount') / 100),
        details = object.get('details'),
        discount = object.get('discount');
}
