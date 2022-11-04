// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: use_key_in_widget_constructors, unused_import, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/auth.dart';
import 'package:my_mob_shop/providers/cart.dart';
import 'package:my_mob_shop/providers/orders.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/providers/users.dart';
import 'package:my_mob_shop/screens/auth_screen.dart';
import 'package:my_mob_shop/screens/cart_screen.dart';
import 'package:my_mob_shop/screens/edit_product_screen.dart';
import 'package:my_mob_shop/screens/filters_screen.dart';
import 'package:my_mob_shop/screens/orders_screen.dart';
import 'package:my_mob_shop/screens/product_detail_screen.dart';
import 'package:my_mob_shop/screens/products_overview_screen.dart';
import 'package:my_mob_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// whenever your initialization is completed, remove the splash screen:
    Future.delayed(Duration(seconds: 5))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', '', []),
          update: (context, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', '', []),
            update: (context, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders)),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (context) => Users('', '', []),
          update: (context, auth, previousUsers) => Users(
            auth.token,
            auth.userId,
            previousUsers == null ? [] : previousUsers.users,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Welcome to Flutter',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
            canvasColor: Color.fromARGB(255, 18, 16, 55),
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            FiltersScreen.routeName: (context) => FiltersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
