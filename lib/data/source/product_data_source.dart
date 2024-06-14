import 'package:flutter/material.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/product.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchTerm);
}

class ProductRemoteDataSource implements IProductDataSource {
  @override
  Future<List<ProductEntity>> getAll(int sort) async {
    final ParseObject productsOnServer = ParseObject("Products");
    debugPrint("Getting Products from server...");
    final List<ProductEntity> products = [];
    try {
      final ParseResponse data = await productsOnServer.getAll();
      if (data.results != null) {
        for (var object in data.results!) {
          debugPrint(object.toString());
          ProductEntity prod = ProductEntity.fromObject(object);
          products.add(prod);
        }
      }
    } catch (error) {
      throw AppException(message: error.toString());
    }

    return products;
  }

  @override
  Future<List<ProductEntity>> search(String searchTerm) async {
    final List<ProductEntity> products = [];

    try {
      final ParseObject productsOnServer = ParseObject("Products");
      final parseQuery = QueryBuilder<ParseObject>(productsOnServer);
      parseQuery.whereContains('title', searchTerm);
      final ParseResponse response = await parseQuery.query();

      if (response.success && response.results != null) {
        final products = <ProductEntity>[];
        for (var element in response.result) {
          products.add(ProductEntity.fromObject(element));
        }
      }
    } catch (error) {
      throw AppException(message: error.toString());
    }
    return products;
  }
}
