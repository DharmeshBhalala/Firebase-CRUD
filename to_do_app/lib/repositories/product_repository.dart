import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/models/product_model.dart';
import 'dart:async';

class ProductRepository {
  static final ProductRepository _singleton = ProductRepository._internal();
  final _productsCollection = FirebaseFirestore.instance.collection('products');

  ProductRepository._internal();

  static ProductRepository getInstance() {
    return _singleton;
  }

  Future<String> createNewProduct(ProductModel productModel) async {
    final result = await verifyProductName(productModel.productName!, true);
    if (result == 'No any match found') {
      final newDocRef = _productsCollection.doc(productModel.productId);
      ProductModel newProduct = productModel.copyWith(productId: newDocRef.id);
      await newDocRef.set(newProduct.toMap());
    }
    return result;
  }

  Future<String> verifyProductName(String productName, bool isAddingProduct) async  {
    String result = "No any match found";
    await  _productsCollection.get().then((snapshot) {
      int count = 0;
      for (DocumentSnapshot ds in snapshot.docs) {
        ProductModel productModel = ProductModel.fromMap(ds.data() as Map<String, dynamic>);
        if (productModel.productName == productName) {
          ++count;
          if (isAddingProduct && count == 1) {
            result = "Already used this product name in database";
            break;
          }
          else if(!isAddingProduct && count == 1) {
            result = "Already used this product name in database";
            if (count == 2) {
              break;
            }
          }
        }
      }
    });
    return result;
  }

  Stream<List<ProductModel>> getAllProducts(int filterIndex) {
    
    final filterMap = {
      1: ProductModelField.productName,
      2: ProductModelField.launchSite,
      3: ProductModelField.launchedAt,
      4: ProductModelField.popularity,
    };

    return _productsCollection
        .orderBy(filterMap[filterIndex] as Object, descending: false)
        .snapshots()
        .transform(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
          List<ProductModel>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<ProductModel>> sink) {
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final products = snaps
              .map((json) => ProductModel.fromMap(json as Map<String, dynamic>))
              .toList();
          sink.add(products);
        },
      ),
    );
  }

  Future<String> updateProduct(ProductModel product) async {
    final result = await verifyProductName(product.productName!, false);
    if (result == 'No any match found') {
    await _productsCollection.doc(product.productId).set(product.toMap());
    }
    return result;
  }

  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).delete();
  }

}
