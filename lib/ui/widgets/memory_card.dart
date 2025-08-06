import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memo_fun/models/card_model.dart';

class MemoryCard extends StatefulWidget {
  const MemoryCard({
    required this.card,
    required this.index,
    required this.onCardPressed,
    this.gridSize = 4, // Add gridSize parameter
    super.key,
  });

  final CardItem card;
  final int index;
  final ValueChanged<int> onCardPressed;
  final int gridSize; // Grid size to adjust padding

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.state != CardState.hidden && oldWidget.card.state == CardState.hidden) {
      _animationController.forward();
    } else if (widget.card.state == CardState.hidden && oldWidget.card.state != CardState.hidden) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleCardTap() {
    if (widget.card.state == CardState.hidden) {
      setState(() {
        _isPressed = true;
      });
      
      Timer(const Duration(milliseconds: 150), () {
        setState(() {
          _isPressed = false;
        });
        widget.onCardPressed(widget.index);
      });
    }
  }

  // Calculate responsive padding based on grid size
  EdgeInsets _getResponsivePadding() {
    switch (widget.gridSize) {
      case 2:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case 3:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
      case 4:
        return const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0);
      case 5:
        return const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0);
      case 6:
        return const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0);
      default:
        return const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0);
    }
  }

  // Calculate responsive icon size based on grid size
  double _getResponsiveIconSize() {
    switch (widget.gridSize) {
      case 2:
        return 60.0;
      case 3:
        return 50.0;
      case 4:
        return 40.0;
      case 5:
        return 32.0;
      case 6:
        return 28.0;
      default:
        return 24.0;
    }
  }

  // Calculate responsive question mark size
  double _getResponsiveQuestionSize() {
    switch (widget.gridSize) {
      case 2:
        return 48.0;
      case 3:
        return 40.0;
      case 4:
        return 32.0;
      case 5:
        return 28.0;
      case 6:
        return 24.0;
      default:
        return 20.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getResponsivePadding(),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleCardTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.95 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.2),
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 2 : 6),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: _getCardGradient(),
                    border: Border.all(
                      color: _getBorderColor(),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        // Background pattern
                        if (widget.card.state == CardState.hidden)
                          _buildCardBack()
                        else
                          _buildCardFront(),
                        
                        // Shine effect
                        if (widget.card.state == CardState.guessed)
                          _buildShineEffect(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6A1B9A).withOpacity(0.8),
            const Color(0xFF9C27B0).withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Geometric pattern
          CustomPaint(
            size: Size.infinite,
            painter: _CardBackPainter(),
          ),
          // Question mark
          Center(
            child: Icon(
              Icons.help_outline,
              color: Colors.white,
              size: _getResponsiveQuestionSize(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.card.color,
            widget.card.color.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          widget.card.icon,
          color: Colors.white,
          size: _getResponsiveIconSize(),
          shadows: const [
            Shadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShineEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.transparent,
              Colors.white.withOpacity(0.1),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getCardGradient() {
    if (widget.card.state == CardState.hidden) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF6A1B9A).withOpacity(0.8),
          const Color(0xFF9C27B0).withOpacity(0.6),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          widget.card.color,
          widget.card.color.withOpacity(0.8),
        ],
      );
    }
  }

  Color _getBorderColor() {
    switch (widget.card.state) {
      case CardState.hidden:
        return Colors.white.withOpacity(0.3);
      case CardState.visible:
        return Colors.white.withOpacity(0.8);
      case CardState.guessed:
        return Colors.yellow.withOpacity(0.8);
    }
  }
}

class _CardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw diagonal lines pattern
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, i * size.height / 10),
        Offset(size.width, i * size.height / 10),
        paint,
      );
      canvas.drawLine(
        Offset(i * size.width / 10, 0),
        Offset(i * size.width / 10, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}