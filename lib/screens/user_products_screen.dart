// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/screens/edit_product_screen.dart';
import 'package:my_mob_shop/widgets/app_drawer.dart';
import 'package:my_mob_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshGames(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: Text('Your Games'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshGames(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: SpinKitFadingCircle(
                  itemBuilder: (context, index) {
                    final colors = [
                      Colors.white,
                      Colors.blue,
                      Colors.indigo,
                      Colors.deepOrange
                    ];
                    final color = colors[index % colors.length];
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  size: 100,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshGames(context),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.indigo.withOpacity(0.5),
                      //Colors.white.withOpacity(0.5),
                      Colors.black.withOpacity(0.7),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Consumer<Products>(
                            builder: (ctx, productsData, _) => ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, index) => Column(
                                children: <Widget>[
                                  UserProductItem(
                                    productsData.items[index].id!,
                                    productsData.items[index].title,
                                    productsData.items[index].imageUrl,
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EditProductScreen.routeName);
                        },
                        child: Text('ADD NEW GAME'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
