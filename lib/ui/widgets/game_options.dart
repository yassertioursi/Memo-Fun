import 'package:flutter/material.dart';
import 'package:memo_fun/ui/pages/memory_match_page.dart';
import 'package:memo_fun/ui/widgets/game_button.dart';
import 'package:memo_fun/utils/constants.dart';

class GameOptions extends StatelessWidget {
  const GameOptions({
    super.key,
  });

  static Route<dynamic> _routeBuilder(BuildContext context, int gameLevel) {
    return MaterialPageRoute(
      builder: (_) {
        return MemoryMatchPage(gameLevel: gameLevel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Purple color variations for different levels
   

   
 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: gameLevels.asMap().entries.map((entry) {
          int index = entry.key;
          Map level = entry.value;
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          // Difficulty icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              difficultyIcons[index],
                              color: purpleColors[index],
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Game button
                          Expanded(
                            child: GameButton(
                              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                                  _routeBuilder(context, level['level']),
                                  (Route<dynamic> route) => false),
                              title: level['title'],
                              color: purpleColors[index % purpleColors.length],
                              height: 50,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}