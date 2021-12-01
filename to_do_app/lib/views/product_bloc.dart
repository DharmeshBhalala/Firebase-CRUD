import 'package:to_do_app/models/product_model.dart';
import 'package:to_do_app/repositories/product_repository.dart';

class ProductBloc {
  Future<String> addNewProduct(ProductModel productModel) async {
    return await ProductRepository.getInstance().createNewProduct(productModel);
  }

  Future<String> updateProduct(ProductModel productModel) async {
    return await ProductRepository.getInstance().updateProduct(productModel);
  }
}