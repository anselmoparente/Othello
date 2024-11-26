class CellModel {
  final int index;
  final bool valid;
  final bool empty;

  CellModel({
    required this.index,
    required this.valid,
    required this.empty,
  });

  factory CellModel.initial(int index) {
    return CellModel(
      empty: !isValid(index) || _isCenter(index),
      index: index,
      valid: isValid(index),
    );
  }

  CellModel switchEmpty() =>
      CellModel(index: index, valid: valid, empty: !empty);

  static bool isValid(int index) {
    if (index < 0 || index >= 77) return false;
    final x = index % 11;
    final y = index ~/ 11;
    return ((x > 3 && x < 7) || (y > 1 && y < 5 && x > 1 && x < 9));
  }

  static bool isAnAuxiliaryHorizontalCell(int index) {
    final x = index % 11;
    return (x < 2 || x > 8);
  }

  static bool _isCenter(int index) => index == 38;
}
