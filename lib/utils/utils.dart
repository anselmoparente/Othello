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

/// Verifica se o índice está dentro dos limites do tabuleiro e mantém-se alinhado em termos de colunas.
bool _isWithinBounds(int startIndex, int currentIndex, int direction) {
  if (direction == -1 || direction == 1) {
    // Verifica borda esquerda/direita para movimentos horizontais
    return (startIndex ~/ 8) == (currentIndex ~/ 8);
  }
  return true; // Para movimentos verticais ou diagonais
}

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
