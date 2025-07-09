class Tile {
  final int value;
  final bool isEmpty;

  const Tile({required this.value, this.isEmpty = false});

  Tile copyWith({int? value, bool? isEmpty}) {
    return Tile(value: value ?? this.value, isEmpty: isEmpty ?? this.isEmpty);
  }
}
