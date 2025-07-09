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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;
    final value = widget.tile.value;

    final lightGradients = [
      [Colors.grey[200]!, Colors.grey[300]!],
      [Colors.blue[100]!, Colors.blue[200]!],
      [Colors.blue[200]!, Colors.blue[400]!],
      [Colors.indigo[300]!, Colors.indigo[400]!],
      [Colors.deepPurple[300]!, Colors.deepPurple[500]!],
      [Colors.purple[300]!, Colors.purple[500]!],
      [Colors.pink[300]!, Colors.pink[400]!],
      [Colors.red[300]!, Colors.red[400]!],
      [Colors.orange[300]!, Colors.orange[400]!],
      [Colors.green[300]!, Colors.green[500]!],
    ];

    final darkGradients = [
      [Colors.grey[800]!, Colors.grey[700]!],
      [Colors.blueGrey[700]!, Colors.blueGrey[600]!],
      [Colors.indigo[700]!, Colors.indigo[500]!],
      [Colors.deepPurple[700]!, Colors.deepPurple[500]!],
      [Colors.purple[700]!, Colors.purple[500]!],
      [Colors.pink[700]!, Colors.pink[400]!],
      [Colors.red[700]!, Colors.red[500]!],
      [Colors.orange[700]!, Colors.orange[600]!],
      [Colors.green[700]!, Colors.green[500]!],
      [Colors.teal[700]!, Colors.teal[500]!],
    ];

    final gradient = (brightness == Brightness.dark ? darkGradients : lightGradients)[value % lightGradients.length];

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 150),
      left: widget.offset.dx * widget.tileSize,
      top: widget.offset.dy * widget.tileSize,
      child: GestureDetector(
        onTap: _onTap,
        onPanUpdate: (details) {
          final dx = details.delta.dx;
          final dy = details.delta.dy;
          final direction = (dx.abs() > dy.abs()) ? (dx > 0 ? "right" : "left") : (dy > 0 ? "down" : "up");
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
