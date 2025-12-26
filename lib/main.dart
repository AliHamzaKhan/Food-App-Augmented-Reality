import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoodARApp());
}

class FoodARApp extends StatelessWidget {
  const FoodARApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food AR App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
