// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  ProductsGrid(
    this.showFavorites,
  );
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorites
        ? productsData.favoriteItems
        : productsData.available.isEmpty
            ? productsData.items
            : productsData.available;

    /*final products = productsData.available.isEmpty
        ? productsData.items
        : showFavorites
            ? productsData.favoriteItems
            : productsData.available;*/
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ));
  }
}
