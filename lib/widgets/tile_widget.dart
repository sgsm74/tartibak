import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tartibak/models/tile_model.dart';

class AnimatedTile extends StatefulWidget {
  final Tile tile;
  final double tileSize;
  final Offset offset;
  final VoidCallback onTap;
  final void Function(String direction) onSwipe;

  const AnimatedTile({
    super.key,
    required this.tile,
    required this.tileSize,
    required this.offset,
    required this.onTap,
    required this.onSwipe,
  });

  @override
  State<AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150), lowerBound: 0.95, upperBound: 1.0);
    _scale = CurvedAnimation(parent: _bounceController, curve: Curves.easeOut);
    _bounceController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onTap() {
    _bounceController.reverse().then((_) {
      _bounceController.forward();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final value = widget.tile.value;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      left: widget.offset.dx * widget.tileSize,
      top: widget.offset.dy * widget.tileSize,
      child: GestureDetector(
        onTap: _onTap,
        onPanEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond;
          final dx = velocity.dx;
          final dy = velocity.dy;

          final absDx = dx.abs();
          final absDy = dy.abs();

          if (absDx < 50 && absDy < 50) {
            // حرکت خیلی کوچک، نادیده بگیر
            return;
          }

          final angle = atan2(dy, dx) * 180 / pi;

          String direction;

          if (angle >= -45 && angle <= 45) {
            direction = "right";
          } else if (angle > 45 && angle < 135) {
            direction = "down";
          } else if (angle >= 135 || angle <= -135) {
            direction = "left";
          } else {
            direction = "up";
          }
          widget.onSwipe(direction);
        },
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: widget.tileSize - 4,
            height: widget.tileSize - 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.primary]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.4 : 0.2),
                  blurRadius: 8,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: GoogleFonts.robotoMono(fontSize: widget.tileSize / 2.8, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
