// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:my_mob_shop/screens/products_overview_screen.dart';
import 'package:my_mob_shop/screens/tabs_screens/sports_screens.dart';
import 'package:my_mob_shop/widgets/app_drawer.dart';

class TabsScreen extends StatefulWidget {
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': ProductsOverviewScreen(),
        'title': 'All',
      },
      {
        'page': SportsScreen(),
        'title': 'Sports',
      },
    ];
    super.initState();
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(),
        /*body: _pages[_selectedPageIndex]['page'],
        
        bottomNavigationBar: BottomNavigationBar(
          onTap: selectPage,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_football),
              label: 'Sports',
            )
          ],
        ),*/
        body: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              child: TabBar(tabs: [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Sports',
                )
              ]),
            ),
            TabBarView(
              children: [
                Text(
                  'All',
                  style: TextStyle(color: Colors.white),
                ),
                SportsScreen(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
