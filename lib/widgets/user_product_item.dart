// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_import, deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () => deleteProd(context),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteProd(BuildContext context) async {
    // try {
    await Provider.of<Products>(context, listen: false).deleteProduct(id);
    /*} catch (error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('An error occured'),
              content: Text('Something went wrong!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          });
    }*/
  }
}
