import 'package:flutter/material.dart';

import '../core/dto/dto.dart';
import '../models/cell_model.dart';
import '../models/destination_model.dart';

List<DestinationModel> findValidMoves(int pieceValue, List<CellModel> board) {
  const int boardSize = 8;
  const directions = [-8, 8, -1, 1, -9, -7, 7, 9];

  List<DestinationModel> validMoves = [];

  bool isWithinBounds(int startIndex, int currentIndex, int direction) {
    if (currentIndex < 0 || currentIndex >= board.length) return false;

    if (direction == -1 || direction == 1) {
      final startRow = startIndex ~/ boardSize;
      final currentRow = currentIndex ~/ boardSize;
      return startRow == currentRow;
    }

    return true;
  }

  for (var cell in board) {
    if (cell.value != null) continue;

    bool isValid = false;

    for (var direction in directions) {
      int currentIndex = cell.index + direction;
      bool foundOpponentPiece = false;

      while (isWithinBounds(cell.index, currentIndex, direction) &&
          currentIndex >= 0 &&
          currentIndex < board.length) {
        var neighbor = board[currentIndex];

        if (neighbor.value == null) break;
        if (neighbor.value == pieceValue) {
          if (foundOpponentPiece) {
            isValid = true;
          }
          break;
        }

        foundOpponentPiece = true;
        currentIndex += direction;
      }

      if (isValid) break;
    }

    if (isValid) {
      validMoves.add(DestinationModel(destination: cell.index));
    }
  }

  return validMoves;
}

List<CellModel> updateBoardAfterMove(
    int index, int value, List<CellModel> board) {
  const int boardSize = 8;
  const directions = [-8, 8, -1, 1, -9, -7, 7, 9];

  bool isValidPosition(int currentIndex, int direction) {
    if (currentIndex < 0 || currentIndex >= board.length) return false;

    if (direction == -1 || direction == 1) {
      final currentRow = currentIndex ~/ boardSize;
      final nextRow = (currentIndex + direction) ~/ boardSize;
      return currentRow == nextRow;
    }

    return true;
  }

  void flipPiecesInDirection(int startIndex, int direction) {
    List<int> piecesToFlip = [];
    int currentIndex = startIndex + direction;

    while (isValidPosition(currentIndex, direction) &&
        board[currentIndex].value != null &&
        board[currentIndex].value != value) {
      piecesToFlip.add(currentIndex);
      currentIndex += direction;
    }

    if (isValidPosition(currentIndex, direction) &&
        board[currentIndex].value == value) {
      for (int indexToFlip in piecesToFlip) {
        board[indexToFlip].value = value;
      }
    }
  }

  board[index].value = value;

  for (int direction in directions) {
    flipPiecesInDirection(index, direction);
  }

  return board;
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
  bool hasValidMoveBlack = findValidMoves(0, board).isNotEmpty;
  bool hasValidMoveWhite = findValidMoves(1, board).isNotEmpty;

  return !hasValidMoveBlack && !hasValidMoveWhite;
}

int? getWinner(List<CellModel> board) {
  int blackCount = 0;
  int whiteCount = 0;

  for (var cell in board) {
    if (cell.value == 0) {
      blackCount++;
    } else if (cell.value == 1) {
      whiteCount++;
    }
  }

  if (blackCount > whiteCount) {
    return 0;
  } else if (whiteCount > blackCount) {
    return 1;
  } else {
    return null;
  }
}

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
