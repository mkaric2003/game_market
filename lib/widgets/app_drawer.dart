// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_mob_shop/providers/auth.dart';
import 'package:my_mob_shop/providers/users.dart';
import 'package:my_mob_shop/screens/filters_screen.dart';
import 'package:my_mob_shop/screens/orders_screen.dart';
import 'package:my_mob_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    Provider.of<Users>(context, listen: false).fetchAndSetUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final userIndex = Provider.of<Users>(context, listen: false)
        .users
        .indexWhere((user) => user.id == userId);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.indigo.withOpacity(0.5),
            //Colors.white.withOpacity(0.5),
            Colors.black.withOpacity(0.7),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          children: <Widget>[
            Consumer<Users>(
              builder: (context, userData, _) => Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Color.fromARGB(255, 10, 19, 65),
                    title: Center(
                      child: Text(
                        'Welcome ${userData.users[userIndex + 1].nickname}!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(userData.users[userIndex + 1].imageUrl),
                    minRadius: 35,
                    maxRadius: 55,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    userData.users[userIndex + 1].nickname,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.shop,
                color: Colors.white,
              ),
              title: Text(
                'Shop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.white,
              ),
              title: Text(
                'Orders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(FiltersScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: Text(
                'Your Games',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
