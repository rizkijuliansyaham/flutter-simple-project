import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/feature/home/model/user.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  int page = 1;
  bool _isLoading = false;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  UserProvider(){
    fetchUsers();
  }

  void resetData(){
    _users.clear();
    page = 1;
    fetchUsers();
  }
  

  Future<void> fetchUsers() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _users.addAll((data['data'] as List).map((json) => UserModel.fromJson(json)).toList());
      page++;
    } else {
      throw Exception('Failed to load users');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser(UserModel user) async {
    final response = await http.post(
      Uri.parse(' https://reqres.in/api/users'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'name': user.name,
        'email': user.email,
      }),
    );

    if (response.statusCode == 201) {
      UserModel newUser = UserModel.fromJson(json.decode(response.body));
      _users.insert(0, newUser);
      notifyListeners();
    } else {
      throw Exception('Failed to create user');
    }
  }
}
