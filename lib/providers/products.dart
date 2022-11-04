// ignore_for_file: unused_field, prefer_final_fields, unused_element, use_rethrow_when_possible, unused_local_variable, null_check_always_fails

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_mob_shop/models/http_exception.dart';
import 'package:my_mob_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  Map<String, bool> filters = {
    'action': false,
    'sport': false,
    'strategy': false,
    'battleRoyal': false,
  };
  final String token;
  final String userId;

  Products(this.token, this.userId, this._items);

  List<Product> available = [];

  void setFilters(Map<String, bool> filterData) {
    filters = filterData;
    available = _items.where((game) {
      if (filters['action'] == true && !game.isAction) {
        return false;
      }
      if (filters['sport'] == true && !game.isSport) {
        return false;
      }
      if (filters['strategy'] == true && !game.isStrategy) {
        return false;
      }
      if (filters['battleRoyal'] == true && !game.isbattleRoyal) {
        return false;
      }
      return true;
    }).toList();
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Product> get sportsItems {
    return _items.where((item) => item.isSport).toList();
  }

  List<Product> get actionItems {
    return _items.where((item) => item.isAction).toList();
  }

  List<Product> get battleRoyalItem {
    return _items.where((item) => item.isbattleRoyal).toList();
  }

  List<Product> get strategyItems {
    return _items.where((item) => item.isStrategy).toList();
  }

  Product findById(productId) {
    return items.firstWhere((prod) => prod.id == productId);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/products.json?auth=$token&$filterString');
    try {
      final response = await http.get(url);
      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;

      url = Uri.parse(
          'https://my-mob-shop-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      List<Product> loadedProducts = [];
      extractedProducts.forEach((prodId, prodData) {
        loadedProducts.insert(
          0,
          Product(
              id: prodId,
              title: prodData['title'],
              imageUrl: prodData['imageUrl'],
              videoUrl: prodData['videoUrl'],
              description: prodData['description'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
              isSport: prodData['isSport'],
              isAction: prodData['isAction'],
              isStrategy: prodData['isStrategy'],
              isbattleRoyal: prodData['isBattleRoyal']),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'videoUrl': product.videoUrl,
            'price': product.price,
            'isSport': product.isSport,
            'isAction': product.isAction,
            'isStrategy': product.isStrategy,
            'isBattleRoyal': product.isbattleRoyal,
            'creatorId': userId,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        imageUrl: product.imageUrl,
        videoUrl: product.videoUrl,
        description: product.description,
        price: product.price,
        isSport: product.isSport,
        isStrategy: product.isStrategy,
        isbattleRoyal: product.isbattleRoyal,
        isAction: product.isAction,
      );
      _items.insert(0, newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/products/$id.json?auth=$token');

    if (prodIndex >= 0) {
      final response = await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'videoUrl': newProduct.videoUrl,
            'price': newProduct.price,
            'isSport': newProduct.isSport,
            'isAction': newProduct.isAction,
            'isStrategy': newProduct.isStrategy,
            'isBattleRoyal': newProduct.isbattleRoyal,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
    final existingProdIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProd = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    existingProd = null!;
  }
}
