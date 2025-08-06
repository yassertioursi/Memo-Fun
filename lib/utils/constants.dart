import 'package:flutter/material.dart';

const Color continueButtonColor = Color.fromRGBO(235, 32, 93, 1);
const Color restartButtonColor = Color.fromRGBO(243, 181, 45, 1);
const Color quitButtonColor = Color.fromRGBO(39, 162, 149, 1);

const List<Map<String, dynamic>> gameLevels = [
  {'title': '4 x 4', 'level': 4, 'color': Colors.blueAccent},
  {'title': '6 x 6', 'level': 6, 'color': Colors.cyanAccent},
];

 const purpleColors = [
       Color(0xFF8E24AA), // Light purple
        Color(0xFF7B1FA2), // Medium purple
       Color(0xFF6A1B9A), // Purple
       Color(0xFF4A148C), // Deep purple
     
      
    ];

   final difficultyIcons = [
      Icons.sentiment_satisfied, // Easy - Happy face
      Icons.sentiment_neutral,   // Medium - Neutral face
      Icons.sentiment_dissatisfied, // Hard - Concerned face
      Icons.local_fire_department, // Expert - Fire icon
    ];
const String gameTitle = 'Memo Fun';