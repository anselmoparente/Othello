import 'package:flutter/material.dart';

import '../models/cell_model.dart';
import '../models/destination_model.dart';
import 'circle_widget.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    super.key,
    required this.selectedIndex,
    required this.cell,
    required this.onTap,
    required this.destinations,
    required this.myTurn,
    required this.gameOver,
  });

  final int selectedIndex;
  final CellModel cell;
  final List<DestinationModel> destinations;
  final void Function(CellModel) onTap;
  final bool myTurn;
  final bool gameOver;

  @override
  Widget build(BuildContext context) {
    if (cell.value == null && !_isDestination) {
      return const SizedBox.shrink();
    }

    final child = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: _getElevation(),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _isDestination == true ? onTap(cell) : null,
          customBorder: const CircleBorder(),
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              CircleWidget(color: _getBackgroundColor()),
            ],
          ),
        ),
      ),
    );

    if (_value != null || !myTurn || gameOver) return child;

    return Draggable<CellModel>(
      data: cell,
      feedback: SizedBox.square(
        dimension: 64.0,
        child: child,
      ),
      childWhenDragging: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleWidget(
          color: Colors.black,
        ),
      ),
      onDragStarted: () {
        if (!_selected) {
          onTap(cell);
        }
      },
      child: child,
    );
  }

  double _getElevation() {
    if (_value != null) return 0.0;
    return 12.0;
  }

  Color _getBackgroundColor() {
    if (_value != null) {
      return _value == 0 ? Colors.black : Colors.white;
    } else if (_isDestination) {
      return Colors.grey.shade400;
    }
    return Colors.transparent;
  }

  bool get _isDestination =>
      destinations.any((destination) => destination.destination == cell.index);

  bool get _selected => cell.index == selectedIndex;

  int? get _value => cell.value;
}
