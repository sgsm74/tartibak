import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tartibak/viewmodels/puzzle_view_model.dart';
import '../widgets/tile_widget.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key, this.gridSize = 3});
  final int gridSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChangeNotifierProvider(
      create: (_) => PuzzleViewModel(gridSize: gridSize),
      child: Consumer<PuzzleViewModel>(
        builder: (_, vm, __) {
          final screenSize = MediaQuery.of(context).size;
          final boardSize = screenSize.width - 32;
          final tileSize = boardSize / vm.gridSize;

          if (vm.isCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text("🎉 تبریک!", textAlign: TextAlign.center),
                      content: Text(
                        "شما پازل را با ${vm.moveCount} حرکت و در ${_formatTime(vm.secondsElapsed)} حل کردید.",
                        textAlign: TextAlign.center,
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.replay),
                          label: const Text("شروع دوباره"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            vm.reset();
                          },
                        ),
                      ],
                    ),
              );
            });
          }

          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "پازل عددی",
                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'IranSansNum'),
              ),
              centerTitle: true,
              actions: [IconButton(icon: Icon(Icons.refresh, color: colorScheme.onSurface), tooltip: "شروع دوباره", onPressed: vm.reset)],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InfoCard(label: "حرکت‌ها", value: "${vm.moveCount}"),
                      _InfoCard(label: "زمان", value: _formatTime(vm.secondsElapsed)),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: boardSize,
                      height: boardSize,
                      child: Stack(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.tiles.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: vm.gridSize),
                            itemBuilder:
                                (_, __) => Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                          ),
                          ...[
                            for (int index = 0; index < vm.tiles.length; index++)
                              if (!vm.tiles[index].isEmpty)
                                AnimatedTile(
                                  key: ValueKey(vm.tiles[index].value),
                                  tile: vm.tiles[index],
                                  tileSize: tileSize,
                                  offset: vm.getTileOffset(index),
                                  onTap: () => vm.move(index),
                                  onSwipe: (direction) => vm.moveBySwipe(index, direction),
                                ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colorScheme.secondaryContainer.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}
