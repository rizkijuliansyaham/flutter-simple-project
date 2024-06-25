import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/feature/home/model/user.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  int page = 1;
  bool _isLoading = false;
  bool _isDataLoading = false;

  String _dataResult = '';

  List<UserModel> get users => _users;
  String get dataResult => _dataResult;
  bool get isLoading => _isLoading;
  bool get isDataLoading => _isDataLoading;

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

  Future<void> testPostData(UserModel user) async {
    _isDataLoading = true;
    _dataResult = '';
    notifyListeners();
    final response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      body: user.tojson(),
    );

    if (response.statusCode == 201) {
      _isDataLoading = false;
      _dataResult = JsonEncoder.withIndent('  ').convert(json.decode(response.body));
      notifyListeners();
    } else {
      _isDataLoading = false;
      throw Exception('Failed to test post');
    }
  }

  void resetDataString() {
    _dataResult = ' ';
    notifyListeners();
  }
  
}
