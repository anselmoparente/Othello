import 'package:othello/models/cell_model.dart';

import '../core/dto/dto.dart';
import '../models/chat_message_model.dart';

abstract class GameEvent {}

class NewGameEvent extends GameEvent {
  final int myValue;
  final bool start;
  final String firstPlayer;
  final String secondPlayer;

  NewGameEvent(this.myValue, this.start, this.firstPlayer, this.secondPlayer);
}

class FindDestinations extends GameEvent {
  final int myValue;
  final List<CellModel> board;

  FindDestinations(this.myValue, this.board);
}

class CellTappedEvent extends GameEvent {
  final CellModel cell;

  CellTappedEvent(this.cell);
}

class OpenChatEvent extends GameEvent {}

class SendMessageEvent extends GameEvent {
  final ChatMessageModel message;

  SendMessageEvent(this.message);
}

class WhiteFlagEvent extends GameEvent {}

class SocketDataEvent extends GameEvent {
  final Dto data;
  final bool chatOpen;

  SocketDataEvent({required this.data, required this.chatOpen});
}
