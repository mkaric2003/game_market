// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:my_mob_shop/providers/products.dart';
import 'package:my_mob_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _isSport = false;

  bool _isAction = false;

  bool _isStrategy = false;

  bool _isBattleRoyal = false;

  @override
  void didChangeDependencies() {
    Map current = Provider.of<Products>(context).filters;
    _isSport = current['sport'];
    _isAction = current['action'];
    _isStrategy = current['strategy'];
    _isBattleRoyal = current['battleRoyal'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    Map<String, bool> currentFilters = productsData.filters;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 19, 65),
        title: const Text('Set filters'),
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
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: const Text(
                'Adjust your game selection',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                children: <Widget>[
                  buildSwitchListTile(
                    'Sport',
                    'Only Include E-Sport games',
                    _isSport,
                    (newValue) {
                      setState(() {
                        _isSport = newValue;
                      });
                    },
                  ),
                  buildSwitchListTile(
                    'Action',
                    'Only Include Action games',
                    _isAction,
                    (newValue) {
                      setState(() {
                        _isAction = newValue;
                      });
                    },
                  ),
                  buildSwitchListTile(
                    'Strategy',
                    'Only Include Strategy games',
                    _isStrategy,
                    (newValue) {
                      setState(() {
                        _isStrategy = newValue;
                      });
                    },
                  ),
                  buildSwitchListTile(
                    'BattleRoyal',
                    'Only Include BattleRoyal games',
                    _isBattleRoyal,
                    (newValue) {
                      setState(() {
                        _isBattleRoyal = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(150, 45),
              ),
              onPressed: () {
                currentFilters = {
                  'sport': _isSport,
                  'action': _isAction,
                  'strategy': _isStrategy,
                  'battleRoyal': _isBattleRoyal,
                };
                productsData.setFilters(currentFilters);
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchListTile(
      String title, String subtitle, bool currentValue, dynamic updateValue) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
      value: currentValue,
      onChanged: updateValue,
    );
  }
}
