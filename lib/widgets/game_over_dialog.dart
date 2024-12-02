import 'package:flutter/material.dart';

import '../bloc/game_state.dart';
import 'elevated_button_widget.dart';

AlertDialog gameOverDialog({
  required BuildContext context,
  required GameState state,
  required int? winner,
}) {
  late String gameOverMessage;

  if (state.whiteFlag != null) {
    if (state.whiteFlag == true) {
      gameOverMessage = 'Você ganhou por desistência!';
    } else {
      gameOverMessage = 'Você perdeu por desistência!';
    }
  } else {
    if (winner != null) {
      if (winner == state.myValue) {
        gameOverMessage = 'Parabéns! Você ganhou.';
      } else {
        gameOverMessage = 'Que triste! Você perdeu.';
      }
    } else {
      gameOverMessage = 'Que interessante! Vocês empataram.';
    }
  }

  return AlertDialog(
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      ElevatedButtonWidget(
        onPressed: Navigator.of(context).pop,
        text: 'Ok',
      ),
    ],
    title: const Text(
      'Game over',
      textAlign: TextAlign.center,
    ),
    content: Text(
      gameOverMessage,
      textAlign: TextAlign.center,
    ),
  );
}
