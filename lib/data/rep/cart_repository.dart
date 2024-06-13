import 'package:flutter/material.dart';
import 'package:nike2/data/cart_response.dart';
import 'package:nike2/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource());

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCartNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  void add(int productId, count) => dataSource.add(productId, count);

  @override
  void changeCount(int productId, int count) {
    dataSource.changeCount(productId, count);
  }

  @override
  int count() {
    final count = dataSource.count();
    cartItemCartNotifier.value = count;
    return count;
  }

  @override
  void delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  CartResponse getAll() => dataSource.getAll();
}
