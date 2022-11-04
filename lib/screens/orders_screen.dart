// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_mob_shop/providers/orders.dart' show Orders;
import 'package:my_mob_shop/widgets/app_drawer.dart';
import 'package:my_mob_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future _obtainOrders() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black.withOpacity(0.3),
            Colors.indigo.withOpacity(0.5),
            //Colors.white.withOpacity(0.5),
            Colors.black.withOpacity(0.7),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: FutureBuilder(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
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
                );
              } else if (snapshot.error != null) {
                return Center(
                    child: Text(
                  'No games purchased!',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ));
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
