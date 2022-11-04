// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/game.png'),
            image: NetworkImage(
              product.imageUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () {
                product.toggleFavoriteStatus(auth.token, auth.userId);
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.deepOrange,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(
                product.id!,
                product.price,
                product.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added game to cart!'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.deleteSingleItem(product.id!);
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    );
  }
}
