import 'package:flutter/material.dart';

import '../models/cell_model.dart';
import '../models/destination_model.dart';
import 'circle_widget.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    Key? key,
    required this.selectedIndex,
    required this.cell,
    required this.onTap,
    required this.destinations,
    required this.onCellDropped,
    required this.myTurn,
    required this.gameOver,
  }) : super(key: key);

  final int selectedIndex;
  final CellModel cell;
  final List<DestinationModel> destinations;
  final void Function(CellModel) onTap;
  final void Function(CellModel, CellModel) onCellDropped;
  final bool myTurn;
  final bool gameOver;

  @override
  Widget build(BuildContext context) {
    if (cell.value == null && !cell.valid) {
      return const SizedBox.shrink();
    }

    final child = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: _getElevation(),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => onTap(cell),
          customBorder: const CircleBorder(),
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              CircleWidget(color: _getBackgroundColor()),
              CircleWidget(color: _getOverlayColor()),
            ],
          ),
        ),
      ),
    );

    if (_isDestination) {
      return DragTarget<CellModel>(
        onAccept: (droppedCell) => onCellDropped(droppedCell, cell),
        builder: (context, candidateData, rejectedData) => child,
      );
    }

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
    if (_value != null) return _value == 0 ? Colors.white : Colors.black;
    return Colors.transparent;
  }

  Color _getOverlayColor() {
    if (_isDestination || _selected) return Colors.white.withOpacity(.5);
    return Colors.transparent;
  }

  bool get _isDestination =>
      destinations.map((e) => e.destination).contains(cell.index);

  bool get _selected => cell.index == selectedIndex;

  int? get _value => cell.value;
}
