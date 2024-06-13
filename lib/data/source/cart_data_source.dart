import 'package:nike2/data/cart_response.dart';
// import 'package:nike2/data/cart_response.dart';

abstract class ICartDataSource {
  void add(int productId, int count);
  void changeCount(int cartItemId, int count);
  void delete(int cartItemId);
  int count();
  CartResponse getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  @override
  final CartResponse cart = CartResponse([]);

  @override
  void add(int productId, int count) {
    // cart.cartItems.
    // return AddToCartResponse(productId, count);
  }

  @override
  void changeCount(int productId, int count) {
    for (var i = 0; i < cart.cartItems.length; i++) {
      if (cart.cartItems[i].id == productId) {
        cart.cartItems[i].count = count;
      }
    }
  }

  @override
  void delete(int cartItemId) {
    cart.cartItems.removeWhere((item) => item.id == cartItemId);
  }

  @override
  int count() {
    return cart.cartItems.length;
  }

  @override
  getAll() {
    return cart;
  }
}
