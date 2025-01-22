import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/screens/UserProvider%20.dart';
import 'package:untitled1/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersProvider(),
      child: MaterialApp(
        title: 'Dating App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: const Color(0xFF6C63FF),
        ),
        home: const DatingListScreen(),
      ),
    );
  }
}