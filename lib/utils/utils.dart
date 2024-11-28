import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../core/dto/dto.dart';
import '../models/cell_model.dart';
import '../models/destination_model.dart';

const deltaDestination = [-22, 22, -2, 2];
const deltaEnemy = [-11, 11, -1, 1];

List<DestinationModel> findValidMoves(int pieceValue, List<CellModel> board) {
  // Direções para verificar (horizontal, vertical e diagonais)
  const directions = [
    -8, 8, // vertical (cima, baixo)
    -1, 1, // horizontal (esquerda, direita)
    -9, -7, 7, 9 // diagonais (superiores e inferiores)
  ];

  List<DestinationModel> validMoves = [];

  for (var cell in board) {
    // Somente células vazias podem ser consideradas
    if (cell.value != null) continue;

    bool isValid = false;

    // Verifica todas as direções a partir da célula vazia
    for (var direction in directions) {
      int currentIndex = cell.index + direction;
      bool foundOpponentPiece = false;

      while (_isWithinBounds(cell.index, currentIndex, direction) &&
          currentIndex >= 0 &&
          currentIndex < board.length) {
        var neighbor = board[currentIndex];

        if (neighbor.value == null)
          break; // Célula vazia, não há captura possível
        if (neighbor.value == pieceValue) {
          if (foundOpponentPiece) {
            isValid =
                true; // Jogada válida se encontramos peças adversárias antes
          }
          break;
        }

        foundOpponentPiece = true; // Encontrou peça do adversário
        currentIndex += direction;
      }

      if (isValid)
        break; // Se já for válido, não precisa verificar outras direções
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
  const directions = [
    -8, 8, // vertical (cima, baixo)
    -1, 1, // horizontal (esquerda, direita)
    -9, -7, 7, 9 // diagonais (superiores e inferiores)
  ];

  // Function to validate if the position is within bounds and not wrapping incorrectly
  bool isValidPosition(int currentIndex, int direction, int steps) {
    final row = currentIndex ~/ boardSize;
    final col = currentIndex % boardSize;
    final nextRow = (currentIndex + direction * steps) ~/ boardSize;
    final nextCol = (currentIndex + direction * steps) % boardSize;

    return nextRow >= 0 &&
        nextRow < boardSize &&
        nextCol >= 0 &&
        nextCol < boardSize &&
        ((direction == -1 && nextRow == row) || // Left stays in the same row
            (direction == 1 && nextRow == row) || // Right stays in the same row
            (direction.abs() > 1)); // Vertical or diagonal moves are valid
  }

  // Function to flip pieces in one direction
  void flipPiecesInDirection(int startIndex, int direction) {
    List<int> piecesToFlip = [];
    int currentIndex = startIndex + direction;

    while (isValidPosition(currentIndex, direction, 1) &&
        board[currentIndex].value != null &&
        board[currentIndex].value != value) {
      piecesToFlip.add(currentIndex);
      currentIndex += direction;
    }

    if (isValidPosition(currentIndex, direction, 1) &&
        board[currentIndex].value == value) {
      for (int indexToFlip in piecesToFlip) {
        board[indexToFlip].value = value;
      }
    }
  }

  // Place the new piece
  board[index].value = value;

  // Check all directions to flip pieces
  for (int direction in directions) {
    flipPiecesInDirection(index, direction);
  }

  return board;
}

/// Verifica se o índice está dentro dos limites do tabuleiro e mantém-se alinhado em termos de colunas.
bool _isWithinBounds(int startIndex, int currentIndex, int direction) {
  if (direction == -1 || direction == 1) {
    // Verifica borda esquerda/direita para movimentos horizontais
    return (startIndex ~/ 8) == (currentIndex ~/ 8);
  }
  return true; // Para movimentos verticais ou diagonais
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
    return 0; // Preto vence
  } else if (whiteCount > blackCount) {
    return 1; // Branco vence
  } else {
    return null; // Empate
  }
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
