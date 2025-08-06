import 'package:flutter/material.dart';
import 'package:memo_fun/ui/pages/startup_page.dart';

class TheMemoryMatchGame extends StatelessWidget {
  const TheMemoryMatchGame({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartUpPage(),
      title: 'Memo Fun',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}