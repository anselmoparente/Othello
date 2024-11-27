import 'package:othello/models/cell_model.dart';

import '../models/chat_message_model.dart';
import '../models/destination_model.dart';

class GameState {
  final int selectedIndex;
  final bool soundEnable;
  final List<CellModel> board;
  final List<DestinationModel> availableDestinations;
  final List<ChatMessageModel> messages;
  final int unreadMessagesCount;
  final bool myTurn;
  final int myValue;
  final bool gameOver;
  final bool? whiteFlag;
  final String firstPlayer;
  final String secondPlayer;

  GameState({
    required this.selectedIndex,
    required this.soundEnable,
    required this.board,
    required this.availableDestinations,
    required this.messages,
    required this.unreadMessagesCount,
    required this.myTurn,
    required this.myValue,
    required this.gameOver,
    required this.whiteFlag,
    required this.firstPlayer,
    required this.secondPlayer,
  });

  factory GameState.initial(
    bool myTurn,
    int myValue,
    String firstPlayer,
    String secondPlayer,
  ) {
    return GameState(
      selectedIndex: -1,
      soundEnable: true,
      board: List<CellModel>.generate(64, CellModel.initial),
      availableDestinations: [],
      messages: [],
      unreadMessagesCount: 0,
      myTurn: myTurn,
      myValue: myValue,
      gameOver: false,
      whiteFlag: null,
      firstPlayer: firstPlayer,
      secondPlayer: secondPlayer,
    );
  }

  GameState copyWith({
    int? selectedIndex,
    bool? soundEnable,
    List<CellModel>? board,
    List<DestinationModel>? availableDestinations,
    List<ChatMessageModel>? messages,
    int? unreadMessagesCount,
    bool? myTurn,
    int? myValue,
    bool? gameOver,
    bool? whiteFlag,
    String? firstPlayer,
    String? secondPlayer,
  }) {
    return GameState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      soundEnable: soundEnable ?? this.soundEnable,
      board: board ?? this.board,
      availableDestinations:
          availableDestinations ?? this.availableDestinations,
      messages: messages ?? this.messages,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      myTurn: myTurn ?? this.myTurn,
      myValue: myValue ?? this.myValue,
      gameOver: gameOver ?? this.gameOver,
      whiteFlag: whiteFlag,
      firstPlayer: firstPlayer ?? this.firstPlayer,
      secondPlayer: secondPlayer ?? this.secondPlayer,
    );
  }
}
