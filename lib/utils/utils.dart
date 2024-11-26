import 'dart:io';

import 'package:flutter/material.dart';

import '../core/dto/dto.dart';
import '../models/cell_model.dart';
import '../models/destination_model.dart';

const deltaDestination = [-22, 22, -2, 2];
const deltaEnemy = [-11, 11, -1, 1];

List<DestinationModel> getAvailableDestinations(
  int index,
  List<CellModel> board,
) {
  ////TODO: Corrigir aqui dps
  if (!CellModel.isValid(index) || board[index].value == null) return [];
  final answer = <DestinationModel>[];
  for (int i = 0; i < 4; ++i) {
    final destinationIndex = index + deltaDestination[i];
    final enemyIndex = index + deltaEnemy[i];

    if (CellModel.isValid(destinationIndex) &&
        board[destinationIndex].value != null &&
        board[enemyIndex].value != null) {
      answer.add(
        DestinationModel(
          destination: destinationIndex,
          capture: enemyIndex,
        ),
      );
    }
  }

  return answer;
}

bool isDestination(List<DestinationModel> destinations, CellModel cell) {
  for (final destination in destinations) {
    if (destination.destination == cell.index) {
      return true;
    }
  }
  return false;
}

(String, String) getMatchDisplayOrder(Dto data, String userName) {
  var firstPlayer = data.enemy;
  var secondPlayer = userName;

  if (data.start) {
    firstPlayer = userName;
    secondPlayer = data.enemy;
  }

  return (firstPlayer, secondPlayer);
}

bool isGameOver(List<CellModel> board) {
  final destinations = [
    for (final cell in board) ...getAvailableDestinations(cell.index, board),
  ];
  return destinations.isEmpty;
}

bool get isPlatformDesktop =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
