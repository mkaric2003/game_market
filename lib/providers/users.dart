// ignore_for_file: prefer_final_fields, use_rethrow_when_possible

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String nickname;
  final String imageUrl;

  User({
    required this.id,
    required this.nickname,
    required this.imageUrl,
  });
}

class Users with ChangeNotifier {
  final String token;
  final String userId;
  Users(this.token, this.userId, this._users);

  List<User> _users = [];
  List<User> get users {
    return [..._users];
  }

  Future<void> fetchAndSetUsers() async {
    final url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/users/$userId.json?auth=$token');

    try {
      final response = await http.get(url);
      final extractedUsers = json.decode(response.body) as Map<String, dynamic>;
      List<User> loadedUsers = [];
      extractedUsers.forEach((userID, userData) {
        loadedUsers.insert(
            0,
            User(
              id: userID,
              nickname: userData['nickName'],
              imageUrl: userData['imageUrl'],
            ));
      });
      _users = loadedUsers;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addUser(User user) async {
    final url = Uri.parse(
        'https://my-mob-shop-default-rtdb.firebaseio.com/users/$userId.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'nickName': user.nickname,
            'imageUrl': user.imageUrl,
            'creatorId': userId
          }));
      final newUser = User(
          id: json.decode(response.body)['name'],
          nickname: user.nickname,
          imageUrl: user.imageUrl);
      _users.add(newUser);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
