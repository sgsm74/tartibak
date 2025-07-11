import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tartibak/l10n.dart';
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();

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
    final loc = AppLocalizations(Localizations.localeOf(context));

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // پس زمینه گرادیان متناسب با تم
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primaryContainer.withOpacity(0.7), colorScheme.secondaryContainer.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // پنل شیشه‌ای مات
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: colorScheme.onSurface.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SlideTransition(
                        position: _titleOffset,
                        child: FadeTransition(
                          opacity: _titleOpacity,
                          child: Column(
                            children: [
                              Icon(Icons.extension_rounded, size: 64, color: colorScheme.primary),
                              const SizedBox(height: 16),
                              Text(
                                '${loc.get('title')} 🧩',
                                style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                loc.get('select_size')!,
                                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      SlideTransition(
                        position: _tilesOffset,
                        child: FadeTransition(
                          opacity: _tilesOpacity,
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                sizes.map((size) {
                                  final isSelected = size == selectedSize;
                                  return GestureDetector(
                                    onTap: () => _onSizeChanged(size),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                                      decoration: BoxDecoration(
                                        gradient:
                                            isSelected
                                                ? LinearGradient(colors: [colorScheme.primary, colorScheme.primaryContainer])
                                                : LinearGradient(colors: [colorScheme.surfaceVariant, colorScheme.surface]),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          if (isSelected)
                                            BoxShadow(
                                              color: colorScheme.primary.withOpacity(0.4),
                                              blurRadius: 20,
                                              offset: const Offset(0, 4),
                                            ),
                                        ],
                                      ),
                                      child: Text(
                                        '$size × $size',
                                        style: TextStyle(
                                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      SlideTransition(
                        position: _buttonOffset,
                        child: FadeTransition(
                          opacity: _buttonOpacity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.play_arrow_rounded, size: 28, color: colorScheme.onPrimary),
                            label: Text(loc.get('start_game')!, style: TextStyle(fontSize: 18, color: colorScheme.onPrimary)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 10,
                              shadowColor: colorScheme.primary,
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PuzzlePage(gridSize: selectedSize)));
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextButton.icon(
                        icon: Icon(Icons.settings, color: colorScheme.onSurfaceVariant),
                        label: Text(loc.get('settings')!, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
