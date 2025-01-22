import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class UsersProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<User> _users = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _error = '';
  int _currentPage = 1;
  bool _hasMore = true;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadUsers() async {
    if (_isLoading || !_hasMore) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _dio.get(
        'https://randomuser.me/api/?page=1&results=10',

      );

      final List<User> newUsers = (response.data['results'] as List)
          .map((userData) => User.fromJson(userData))
          .toList();

      if (newUsers.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
        _users.addAll(newUsers);
      }

      _hasError = false;
      _error = '';
    } catch (e) {
      _hasError = true;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _users = [];
    _currentPage = 1;
    _hasMore = true;
    _hasError = false;
    _error = '';
    notifyListeners();
  }
}

class User {
  final String name;
  final int age;
  final String location;
  final String picture;
  final double distance;

  User({
    required this.name,
    required this.age,
    required this.location,
    required this.picture,
    required this.distance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final name = "${json['name']['first']} ${json['name']['last']}";
    return User(
      name: name,
      age: (json['dob']['age'] as num).toInt(),
      location: "${json['location']['city']}, ${json['location']['country']}",
      picture: json['picture']['medium'],
      distance: 3.0, //demo for now
    );
  }
}