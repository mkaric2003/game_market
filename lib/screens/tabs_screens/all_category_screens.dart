// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class AllCategoryScreen extends StatelessWidget {
  final bool showFavorites;

  AllCategoryScreen(this.showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorites
        ? productsData.favoriteItems
        : productsData.available.isEmpty
            ? productsData.items
            : productsData.available;

    return Scaffold(
      body: GridView.builder(
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
              )),
    );
  }
}
