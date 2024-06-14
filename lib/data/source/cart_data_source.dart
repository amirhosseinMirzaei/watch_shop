import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nike2/data/add_to_cart_response.dart';
import 'package:nike2/data/cart_item.dart';
import 'package:nike2/data/cart_response.dart';
import 'package:nike2/data/product.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(String cartItemId);
  Future<AddToCartResponse> changeCount(String cartItemId, int count);
  Future<void> delete(String cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  var cartItems = <String, int>{};

  @override
  Future<AddToCartResponse> add(String cartItemId) async {
    if (cartItems.keys.contains(cartItemId)) {
      cartItems.update(cartItemId, (value) => value + 1);
    } else {
      cartItems.putIfAbsent(
        cartItemId,
        () => 1,
      );
    }
    debugPrint('Item added: $cartItemId');

    // save to local
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final cartData = jsonEncode(cartItems);
    await sp.setString('cart', cartData);

    return AddToCartResponse(cartItemId, cartItems[cartItemId]!);
  }

  @override
  Future<AddToCartResponse> changeCount(String cartItemId, int count) async {
    if (cartItems.keys.contains(cartItemId)) {
      cartItems.update(cartItemId, (value) => count);
    } else {
      cartItems.putIfAbsent(
        cartItemId,
        () => count,
      );
    }

    // save to local
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final cartData = jsonEncode(cartItems);
    await sp.setString('cart', cartData);

    return AddToCartResponse(cartItemId, cartItems[cartItemId]!);
  }

  @override
  Future<int> count() async {
    int sum = 0;
    for (var element in cartItems.values) {
      sum += element;
    }
    return sum;
  }

  @override
  Future<void> delete(String cartItemId) async {
    cartItems.remove(cartItemId);

    // save to local
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final cartData = jsonEncode(cartItems);
    await sp.setString('cart', cartData);
  }

  @override
  Future<CartResponse> getAll() async {
    // read from local
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final jsonData = sp.getString('cart');
    if (jsonData != null) {
      cartItems = Map<String, int>.from(jsonDecode(jsonData));
    }

    final items = <CartItemEntity>[];
    final ParseObject productsOnServer = ParseObject("Products");
    for (var id in cartItems.keys) {
      final response = await productsOnServer.getObject(id);
      if (response.success && response.results != null) {
        final prod = ProductEntity.fromObject(response.result);
        debugPrint('product in cart: $id');
        items.add(CartItemEntity(product: prod, id: id, count: cartItems[id]!));
      }
    }
    return CartResponse(items);
  }
}
