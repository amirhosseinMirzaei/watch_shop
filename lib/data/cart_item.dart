import 'package:nike2/data/product.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CartItemEntity {
  final ProductEntity product;
  final String id;
  int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemEntity({
    required this.product,
    required this.id,
    required this.count,
    this.deleteButtonLoading = false,
    this.changeCountLoading = false,
  });

  CartItemEntity.fromObject(ParseObject object)
      : product = ProductEntity.fromObject(object.get('product')),
        id = object.get('cart_item_id'),
        count = object.get('count');

  static List<CartItemEntity> parseObjectArray(List<ParseObject> objectArray) {
    final List<CartItemEntity> cartItems = [];
    for (var element in objectArray) {
      cartItems.add(CartItemEntity.fromObject(element));
    }
    return cartItems;
  }
}
