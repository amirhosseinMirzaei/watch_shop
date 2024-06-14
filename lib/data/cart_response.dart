import 'package:nike2/data/cart_item.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CartResponse {
  final List<CartItemEntity> cartItems;
  int payablePrice = 0;
  int totalPrice = 0;
  int shippingCost = 0;

  CartResponse(this.cartItems) {
    for (var cartItem in cartItems) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    }
    shippingCost = payablePrice >= 250000 ? 0 : 30000;
  }

  CartResponse.fromObject(ParseObject object)
      : cartItems = CartItemEntity.parseObjectArray(object['cart_items']),
        payablePrice = object.get('payable_price'),
        totalPrice = object.get('total_price'),
        shippingCost = object.get('shipping_cost');
}
