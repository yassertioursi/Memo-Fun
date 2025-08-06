import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memo_fun/models/card_model.dart';
import 'package:memo_fun/models/game_model.dart';
import 'package:memo_fun/ui/widgets/memory_card.dart';
import 'package:memo_fun/ui/pages/startup_page.dart';

class GameBoardMobile extends StatefulWidget {
  const GameBoardMobile({
    required this.gameLevel,
    super.key,
  });

  final int gameLevel;

  @override
  State<GameBoardMobile> createState() => _GameBoardMobileState();
}

class _GameBoardMobileState extends State<GameBoardMobile> {
  late Timer timer;
  late Game game;
  late Duration duration;
  bool isPaused = false;
  
  @override
  void initState() {
    super.initState();
    game = Game(widget.gameLevel);
    duration = const Duration();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!isPaused) {
        setState(() {
          final seconds = duration.inSeconds + 1;
          duration = Duration(seconds: seconds);
        });

        if (game.isGameOver) {
          timer.cancel();
        }
      }
    });
  }

  pauseTimer() {
    setState(() {
      isPaused = true;
    });
  }

  resumeTimer() {
    setState(() {
      isPaused = false;
    });
  }

  void _resetGame() {
    game.resetGame();
    setState(() {
      timer.cancel();
      duration = const Duration();
      isPaused = false;
      startTimer();
    });
  }

  void _goBackToHome() {
    timer.cancel();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const StartUpPage()),
      (Route<dynamic> route) => false,
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _onCardPressed(int index) {
    if (isPaused || game.isGameOver) return;
    
    // Get currently visible cards (not matched)
    List<int> visibleCards = [];
    for (int i = 0; i < game.cards.length; i++) {
      if (game.cards[i].state == CardState.visible) {
        visibleCards.add(i);
      }
    }

    // If 2 cards are already visible and user selects a third one
    if (visibleCards.length >= 2 && !visibleCards.contains(index)) {
      // Hide the previously visible cards
      for (int cardIndex in visibleCards) {
        game.cards[cardIndex].state = CardState.hidden;
      }
      setState(() {});
      
      // Small delay before showing the new card
      Timer(const Duration(milliseconds: 300), () {
        game.onCardPressed(index);
        setState(() {});
      });
    } else {
      // Normal card selection
      game.onCardPressed(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Container(
       padding: const EdgeInsets.symmetric(vertical:  20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6A1B9A), // Deep purple
            Color(0xFF9C27B0), // Purple
            Color(0xFFBA68C8), // Light purple
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: _goBackToHome,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  _formatTime(duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Game Status and Control Bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    // Game Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusItem('Level', '${widget.gameLevel}', Icons.layers),
                        _buildStatusItem('Cards', '${game.cards.length}', Icons.grid_view),
                        _buildStatusItem('Matches', '${game.cards.where((card) => card.isMatched).length ~/ 2}/${game.cards.length ~/ 2}', Icons.check_circle),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: isPaused ? Icons.play_arrow : Icons.pause,
                          label: isPaused ? 'Resume' : 'Pause',
                          onPressed: isPaused ? resumeTimer : pauseTimer,
                          isEnabled: !game.isGameOver,
                        ),
                        _buildControlButton(
                          icon: Icons.refresh,
                          label: 'Restart',
                          onPressed: _resetGame,
                          isEnabled: true,
                        ),
                        _buildControlButton(
                          icon: Icons.home,
                          label: 'Home',
                          onPressed: _goBackToHome,
                          isEnabled: true,
                        ),
                        if (game.isGameOver)
                          _buildControlButton(
                            icon: Icons.celebration,
                            label: 'Complete!',
                            onPressed: () {},
                            isEnabled: false,
                            isSuccess: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Game Grid
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: game.gridSize,
                    childAspectRatio: aspectRatio * 1.8,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(game.cards.length, (index) {
                      return MemoryCard(
                        index: index,
                        card: game.cards[index],
                        onCardPressed: _onCardPressed, // Use custom handler
                        gridSize: game.gridSize,
                      );
                    }),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isEnabled,
    bool isSuccess = false,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSuccess 
            ? Colors.green.withOpacity(0.2)
            : isEnabled 
              ? const Color(0xFF6A1B9A).withOpacity(0.3) 
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSuccess 
              ? Colors.green.withOpacity(0.5)
              : isEnabled
                ? Colors.white.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
          ),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              color: isSuccess 
                ? Colors.green 
                : isEnabled 
                  ? Colors.white 
                  : Colors.grey,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSuccess 
                  ? Colors.green 
                  : isEnabled 
                    ? Colors.white 
                    : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}