// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_mob_shop/providers/orders.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart' as cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: Text('Your cart'),
      ),
      body: Container(
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
            Card(
              elevation: 10,
              color: Colors.black,
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Spacer(),
                    Chip(
                      backgroundColor: Colors.grey,
                      label: Text(
                        '\$${cartData.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    OrderButton(cartData: cartData),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartData.items.length,
                itemBuilder: (ctx, i) => cart.CartItem(
                  cartData.items.values.toList()[i].id,
                  cartData.items.keys.toList()[i],
                  cartData.items.values.toList()[i].title,
                  cartData.items.values.toList()[i].price,
                  cartData.items.values.toList()[i].quantity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cartData.totalAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartData.items.values.toList(),
                widget.cartData.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cartData.clearCart();
            },
      child: _isLoading
          ? SpinKitFadingCircle(
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
              size: 35,
            )
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}
