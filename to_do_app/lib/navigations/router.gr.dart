// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i4;

import '../models/product_model.dart' as _i5;
import '../views/home_view.dart' as _i2;
import '../views/product_view.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeViewRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<HomeViewRouteArgs>(orElse: () => HomeViewRouteArgs());
      return _i1.MaterialPageX(
          entry: entry, child: _i2.HomeView(key: args.key));
    },
    ProductViewRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<ProductViewRouteArgs>(orElse: () => ProductViewRouteArgs());
      return _i1.MaterialPageX(
          entry: entry,
          child: _i3.ProductView(
              key: args.key,
              isEditingProduct: args.isEditingProduct,
              productModel: args.productModel));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeViewRoute.name, path: '/'),
        _i1.RouteConfig(ProductViewRoute.name, path: '/product-view')
      ];
}

class HomeViewRoute extends _i1.PageRouteInfo<HomeViewRouteArgs> {
  HomeViewRoute({_i4.Key? key})
      : super(name, path: '/', args: HomeViewRouteArgs(key: key));

  static const String name = 'HomeViewRoute';
}

class HomeViewRouteArgs {
  const HomeViewRouteArgs({this.key});

  final _i4.Key? key;
}

class ProductViewRoute extends _i1.PageRouteInfo<ProductViewRouteArgs> {
  ProductViewRoute(
      {_i4.Key? key, bool? isEditingProduct, _i5.ProductModel? productModel})
      : super(name,
            path: '/product-view',
            args: ProductViewRouteArgs(
                key: key,
                isEditingProduct: isEditingProduct,
                productModel: productModel));

  static const String name = 'ProductViewRoute';
}

class ProductViewRouteArgs {
  const ProductViewRouteArgs(
      {this.key, this.isEditingProduct, this.productModel});

  final _i4.Key? key;

  final bool? isEditingProduct;

  final _i5.ProductModel? productModel;
}
