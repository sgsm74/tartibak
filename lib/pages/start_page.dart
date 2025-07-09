import 'package:flutter/material.dart';
import 'package:tartibak/pages/settings_page.dart';
import 'puzzle_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  int selectedSize = 3;
  final List<int> sizes = [3, 4, 5];

  late final AnimationController _controller;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _tilesOffset;
  late final Animation<double> _tilesOpacity;
  late final Animation<Offset> _buttonOffset;
  late final Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..forward();

    _titleOffset = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)));

    _tilesOffset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6)));

    _tilesOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6)));

    _buttonOffset = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)));

    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSizeChanged(int size) {
    setState(() => selectedSize = size);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _titleOffset,
                child: FadeTransition(
                  opacity: _titleOpacity,
                  child: Column(
                    children: [
                      Text(
                        '🧩 پازل عددی',
                        style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'سایز پازل رو انتخاب کن و شروع کن',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              SlideTransition(
                position: _tilesOffset,
                child: FadeTransition(
                  opacity: _tilesOpacity,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        sizes.map((size) {
                          final isSelected = selectedSize == size;
                          return GestureDetector(
                            onTap: () => _onSizeChanged(size),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                              decoration: BoxDecoration(
                                gradient:
                                    isSelected
                                        ? LinearGradient(colors: [colorScheme.primary, colorScheme.primaryContainer])
                                        : LinearGradient(colors: [colorScheme.surface, colorScheme.surface]),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: colorScheme.primary, width: 2),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Text(
                                '$size × $size',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              SlideTransition(
                position: _buttonOffset,
                child: FadeTransition(
                  opacity: _buttonOpacity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text('شروع بازی', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      fixedSize: Size(MediaQuery.sizeOf(context).width / 2, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PuzzlePage(gridSize: selectedSize)));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _buttonOffset,
                child: FadeTransition(
                  opacity: _buttonOpacity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.settings_rounded, size: 28),
                    label: const Text('تنظیمات', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.sizeOf(context).width / 2, 64),
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
