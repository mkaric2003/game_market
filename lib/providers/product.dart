import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String imageUrl;
  final String videoUrl;
  final String description;
  final double price;
  bool isFavorite;
  bool isSport;
  bool isStrategy;
  bool isbattleRoyal;
  bool isAction;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.description,
    required this.price,
    this.isFavorite = false,
    this.isSport = false,
    this.isStrategy = false,
    this.isbattleRoyal = false,
    this.isAction = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
