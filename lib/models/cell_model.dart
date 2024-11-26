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

  static bool isValid(int index) => (index >= 0 && index < 64);

  static bool _isCenter(int index) => [27, 28, 35, 36].contains(index);
}
