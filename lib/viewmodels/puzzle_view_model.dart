import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tartibak/models/tile_model.dart';
import 'package:vibration/vibration.dart';

class PuzzleViewModel extends ChangeNotifier {
  final int gridSize;
  late List<Tile> tiles;
  int moveCount = 0;
  bool isCompleted = false;
  final _player = AudioPlayer();
  Timer? _timer;
  int secondsElapsed = 0;
  PuzzleViewModel({this.gridSize = 3}) {
    _initTiles();
  }

  void _initTiles() {
    final total = gridSize * gridSize;
    tiles = List.generate(total, (i) => Tile(value: i + 1, isEmpty: i == total - 1));

    // Shuffle while keeping last tile empty
    tiles.shuffle();
    final emptyIndex = tiles.indexWhere((e) => e.isEmpty);
    moveCount = 0;
    isCompleted = false;

    if (emptyIndex != tiles.length - 1) {
      final last = tiles[tiles.length - 1];
      tiles[tiles.length - 1] = tiles[emptyIndex];
      tiles[emptyIndex] = last;
    }

    notifyListeners();
  }

  void move(int index) {
    if (isCompleted) return;
    final emptyIndex = tiles.indexWhere((e) => e.isEmpty);
    if (_isAdjacent(index, emptyIndex)) {
      final temp = tiles[index];
      tiles[index] = tiles[emptyIndex];
      tiles[emptyIndex] = temp;
      moveCount++;
      _checkCompletion();
      if (moveCount == 1) _startTimer();
      _playClickSound();
      notifyListeners();
    }
  }

  void _checkCompletion() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i].value != i + 1) {
        isCompleted = false;
        return;
      }
    }
    isCompleted = true;
    _stopTimer();
  }

  void moveBySwipe(int index, String direction) {
    final row = index ~/ gridSize;
    final col = index % gridSize;

    final emptyIndex = tiles.indexWhere((t) => t.isEmpty);
    final emptyRow = emptyIndex ~/ gridSize;
    final emptyCol = emptyIndex % gridSize;

    final isUp = direction == "up" && row - 1 == emptyRow && col == emptyCol;
    final isDown = direction == "down" && row + 1 == emptyRow && col == emptyCol;
    final isLeft = direction == "left" && col - 1 == emptyCol && row == emptyRow;
    final isRight = direction == "right" && col + 1 == emptyCol && row == emptyRow;

    if (isUp || isDown || isLeft || isRight) {
      move(index);
    } else {
      _vibrate();
    }
  }

  bool _isAdjacent(int a, int b) {
    final rowA = a ~/ gridSize;
    final colA = a % gridSize;
    final rowB = b ~/ gridSize;
    final colB = b % gridSize;
    return (rowA == rowB && (colA - colB).abs() == 1) || (colA == colB && (rowA - rowB).abs() == 1);
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 10, sharpness: 0.1, amplitude: 180);
    }
  }

  void _playClickSound() async {
    await _player.play(AssetSource('click.mp3'));
  }

  Offset getTileOffset(int index) {
    final row = index ~/ gridSize;
    final col = index % gridSize;
    return Offset(col.toDouble(), row.toDouble());
  }

  void _startTimer() {
    _timer?.cancel();
    secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      secondsElapsed++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void reset() {
    secondsElapsed = 0;
    _stopTimer();
    _initTiles();
  }
}
