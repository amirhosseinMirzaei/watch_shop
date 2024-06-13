import 'package:nike2/data/cart_item.dart';

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

  CartResponse.fromJson(Map<String, dynamic> json)
      : cartItems = CartItemEntity.parseJsonArray(json['cart_items']),
        payablePrice = json['payable_price'],
        totalPrice = json['total_price'],
        shippingCost = json['shipping_cost'];
}
