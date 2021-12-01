import 'dart:convert';
import 'package:to_do_app/utils/utils.dart';

class ProductModelField {
  static final String productName = 'productName';
  static final String launchedAt = 'launchedAt';
  static final String launchSite = 'launchSite';
  static final String popularity = 'popularity';
}

class ProductModel {
  String? productName;
  DateTime? launchedAt;
  String? launchSite;
  double? popularity;
  String? productId;
   
  ProductModel({
    this.productName,
    this.launchedAt,
    this.launchSite,
    this.popularity,
    this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'launchedAt': launchedAt,
      'launchSite': launchSite,
      'popularity': popularity,
      'productId': productId,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productName: map['productName'] != null ? map['productName'] : null,
      launchedAt: map['launchedAt'] != null ? Utils.toDateTime(map['launchedAt']) : null,
      launchSite: map['launchSite'] != null ? map['launchSite'] : null,
      popularity: map['popularity'] != null ? map['popularity'] : null,
      productId: map['productId'] != null ? map['productId'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  ProductModel copyWith({
    String? productName,
    DateTime? launchedAt,
    String? launchSite,
    double? popularity,
    String? productId,
  }) {
    return ProductModel(
      productName: productName ?? this.productName,
      launchedAt: launchedAt ?? this.launchedAt,
      launchSite: launchSite ?? this.launchSite,
      popularity: popularity ?? this.popularity,
      productId: productId ?? this.productId,
    );
  }

  @override
  String toString() {
    return 'ProductModel(productName: $productName, launchedAt: $launchedAt, launchSite: $launchSite, popularity: $popularity, productId: $productId)';
  }
}
