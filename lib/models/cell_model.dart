class CellModel {
  final int index;
  final bool valid;
  int? value;

  CellModel({
    required this.index,
    required this.valid,
    required this.value,
  });

  factory CellModel.initial(int index) {
    return CellModel(
      index: index,
      valid: false,
      value: _isCenter(index) ? _whatColor(index) : null,
    );
  }

  CellModel switchValue(int newValue) =>
      CellModel(index: index, valid: valid, value: newValue);

  static bool isValid(int index) => (index >= 0 && index < 64);

  static bool _isCenter(int index) => [27, 28, 35, 36].contains(index);

  static int _whatColor(int index) => [28, 35].contains(index) ? 0 : 1;

  @override
  String toString() => 'CellModel(index: $index, valid: $valid, value: $value)';
}
