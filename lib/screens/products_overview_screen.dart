// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, unused_field, prefer_final_fields, unused_import, constant_identifier_names, sort_child_properties_last, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/cart.dart';
import 'package:my_mob_shop/providers/product.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/screens/tabs_screens/action_screen.dart';
import 'package:my_mob_shop/screens/cart_screen.dart';
import 'package:my_mob_shop/screens/tabs_screens/all_category_screens.dart';
import 'package:my_mob_shop/screens/tabs_screens/battleRoyal_screen.dart';
import 'package:my_mob_shop/screens/tabs_screens/sports_screens.dart';
import 'package:my_mob_shop/screens/tabs_screens/strategy_screen.dart';

import 'package:my_mob_shop/widgets/app_drawer.dart';
import 'package:my_mob_shop/widgets/badge.dart';
import 'package:my_mob_shop/widgets/product_item.dart';
import 'package:my_mob_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum FilterOptions {
  Favorites,
  Sports,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen>
    with SingleTickerProviderStateMixin {
  var _showOnlyFavorites = false;

  var _isInit = true;
  var _isLoading = false;
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: Text('Game Market'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badge(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: Icon(
                    Icons.shopping_cart_sharp,
                  ),
                ),
                value: cart.itemCount.toString(),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
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
          : Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.indigo.withOpacity(0.5),
                  //Colors.white.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TabBar(
                        labelStyle: TextStyle(fontSize: 18),
                        controller: _tabController,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            text: 'All',
                          ),
                          Tab(
                            text: 'Sports',
                          ),
                          Tab(
                            text: 'Action',
                          ),
                          Tab(
                            text: 'Strategy',
                          ),
                          Tab(
                            text: 'BattleRoyal',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //height: 735,
                      height: MediaQuery.of(context).size.height * 0.85,
                      width: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          AllCategoryScreen(_showOnlyFavorites),
                          SportsScreen(),
                          ActionScreen(),
                          StrategyScreen(),
                          BattleRoyalScreen(),
                        ],
                      ),
                    ),
                    /*Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              setState(() {
                                _showSportsItems = true;
                                _showStrategyItems = false;
                                _showActionItems = false;
                                _showBattleRoyalItems = false;
                                _showOnlyFavorites = false;
                              });
                            },
                            child: Text(
                              'Sports',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showStrategyItems = true;
                                _showSportsItems = false;
                                _showActionItems = false;
                                _showBattleRoyalItems = false;
                                _showOnlyFavorites = false;
                              });
                            },
                            child: Text(
                              'Strategy',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showStrategyItems = false;
                                _showSportsItems = false;
                                _showActionItems = true;
                                _showBattleRoyalItems = false;
                                _showOnlyFavorites = false;
                              });
                            },
                            child: Text(
                              'Action',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showActionItems = false;
                                _showStrategyItems = false;
                                _showSportsItems = false;
                                _showBattleRoyalItems = true;
                                _showOnlyFavorites = false;
                              });
                            },
                            child: Text(
                              'BattleRoyal',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
    );
  }
}
