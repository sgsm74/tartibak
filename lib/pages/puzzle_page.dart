import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tartibak/l10n.dart';
import 'package:tartibak/viewmodels/puzzle_view_model.dart';
import 'package:tartibak/viewmodels/settings_view_model.dart';
import '../widgets/tile_widget.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key, this.gridSize = 3});
  final int gridSize;

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Localizations.localeOf(context));
    final colorScheme = Theme.of(context).colorScheme;
    return ChangeNotifierProvider(
      create: (_) => PuzzleViewModel(gridSize: widget.gridSize, settings: context.read<SettingsViewModel>()),
      child: Consumer<PuzzleViewModel>(
        builder: (_, vm, __) {
          final screenSize = MediaQuery.of(context).size;
          final boardSize = screenSize.width - 32;
          final tileSize = boardSize / vm.gridSize;
          if (vm.isCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text("${loc.get('congrats_title')}! 🎉 ", textAlign: TextAlign.center),
                      content: Text(
                        '${loc.get('congrats_message')}'
                            .replaceAll('{moves}', vm.moveCount.toString())
                            .replaceAll('{time}', _formatTime(vm.secondsElapsed)),
                      ),

                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.replay),
                          label: Text('${loc.get('restart')}'),
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
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                return;
              }
              final bool shouldPop =
                  await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      final theme = Theme.of(context);
                      final colorScheme = theme.colorScheme;

                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: colorScheme.surface,
                        title: Text(
                          loc.get('exit_game_title')!,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                        ),
                        content: Text(
                          loc.get('exit_game_content')!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        actionsAlignment: MainAxisAlignment.end,
                        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(loc.get('exit_game_no')!, style: TextStyle(color: colorScheme.primary)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(loc.get('exit_game_yes')!),
                          ),
                        ],
                      );
                    },
                  ) ??
                  false;
              if (context.mounted && shouldPop) {
                vm.reset();
                Navigator.pop(context, result);
              }
            },
            child: Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  '${loc.get('title')}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'IranSansNum'),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh, color: colorScheme.onSurface),
                    tooltip: '${loc.get('restart')}',
                    onPressed: vm.reset,
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _InfoCard(label: '${loc.get('moves')}', value: "${vm.moveCount}"),
                        _InfoCard(label: '${loc.get('time')}', value: _formatTime(vm.secondsElapsed)),
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
