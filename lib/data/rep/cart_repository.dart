import 'package:flutter/material.dart';
import 'package:nike2/data/add_to_cart_response.dart';
import 'package:nike2/data/cart_response.dart';
import 'package:nike2/data/source/cart_data_source.dart';


final cartRepository = CartRepository(CartRemoteDataSource());

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCartNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(String productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(String cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCartNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(String cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
