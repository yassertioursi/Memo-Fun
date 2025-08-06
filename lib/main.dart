import 'package:flutter/material.dart';
import 'package:memo_fun/memo_fun_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: TheMemoryMatchGame() , 
    );
  }
}

