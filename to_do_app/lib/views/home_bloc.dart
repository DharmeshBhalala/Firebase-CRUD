import 'package:to_do_app/models/product_model.dart';
import 'package:to_do_app/repositories/product_repository.dart';
import 'dart:async';

class HomeBloc {
  Stream<List<ProductModel>> getAllProducts(int filterIndex) {
    return ProductRepository.getInstance().getAllProducts(filterIndex);
  }

  Future<void> deleteProduct(String productId) async {
    return await ProductRepository.getInstance().deleteProduct(productId);
  }
}