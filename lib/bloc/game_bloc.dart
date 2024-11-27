import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../core/client_base.dart';
import '../core/dto/data_type.dart';
import '../models/chat_message_model.dart';
import '../models/destination_model.dart';
import '../utils/utils.dart';
import 'game_events.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final ClientBase _client;

  GameBloc(
    this._client,
    bool myTurn,
    int myValue,
    String firstPlayer,
    String secondPlayer,
  ) : super(GameState.initial(myTurn, myValue, firstPlayer, secondPlayer)) {
    on<CellTappedEvent>(_onCellTapped);
    on<CellDroppedEvent>(_onCellDropped);
    on<FindDestinations>(_onFindDestinations);
    on<SendMessageEvent>(_sendMessage);
    on<SocketDataEvent>(_onSocketData);
    on<OpenChatEvent>(_onOpenChat);
    on<WhiteFlagEvent>(_onWhiteFlag);
    on<NewGameEvent>(_onNewGame);
  }

  void _onCellTapped(CellTappedEvent event, Emitter emit) {
    if (!state.myTurn || state.gameOver) {
      return;
    }

    final cell = event.cell;

    log(state.board.toString());

    // if (isDestination(state.availableDestinations, cell)) {
    //   emit(_makeMovement(state.board[state.selectedIndex].index, cell.index));
    //   return;
    // }

    if (cell.value == null) {
      return;
    }

    int selectIndex = -1;
    List<DestinationModel> destinations = [];

    if (cell.index != state.selectedIndex) {
      selectIndex = cell.index;
      destinations = getAvailableDestinations(cell.index, state.board);
    }

    emit(state.copyWith(
      selectedIndex: selectIndex,
      availableDestinations: destinations,
    ));
  }

  void _onCellDropped(CellDroppedEvent event, Emitter emit) {
    emit(_makeMovement(event.droppedCell.index, event.destinationCell.index));
  }

  void _onFindDestinations(FindDestinations event, Emitter emit) {
    List<DestinationModel> destinations = findValidMoves(
      state.myValue,
      state.board,
    );

    emit(state.copyWith(availableDestinations: destinations));
  }

  void _sendMessage(SendMessageEvent event, Emitter emit) {
    _client.chat(event.message.text);
    emit(state.copyWith(messages: state.messages..add(event.message)));
  }

  void _onSocketData(SocketDataEvent event, Emitter emit) {
    if (event.data.type.equals(DataType.chat)) {
      final message = ChatMessageModel(
        text: event.data.message,
        isMine: false,
      );

      emit(state.copyWith(
        messages: state.messages..add(message),
        unreadMessagesCount: event.chatOpen ? 0 : state.unreadMessagesCount + 1,
      ));
    }

    if (event.data.type.equals(DataType.movement)) {
      emit(_makeMovement(
        event.data.sourceIndex,
        event.data.destinationIndex,
        captureIndex: event.data.captureIndex,
      ));
    }

    if (event.data.type.equals(DataType.whiteFlag)) {
      emit(state.copyWith(gameOver: true, whiteFlag: true));
    }
  }

  void _onOpenChat(OpenChatEvent event, Emitter emit) {
    if (state.unreadMessagesCount > 0) {
      emit(state.copyWith(unreadMessagesCount: 0));
    }
  }

  void _onWhiteFlag(WhiteFlagEvent event, Emitter emit) {
    _client.whiteFlag();
    emit(state.copyWith(gameOver: true, whiteFlag: false));
  }

  void _onNewGame(NewGameEvent event, Emitter emit) {
    emit(GameState.initial(
      event.start,
      event.myValue,
      event.firstPlayer,
      event.secondPlayer,
    ).copyWith(
      messages: state.messages,
      unreadMessagesCount: state.unreadMessagesCount,
      soundEnable: state.soundEnable,
    ));
  }

  GameState _makeMovement(
    int sourceIndex,
    int destinationIndex, {
    int? captureIndex,
  }) {
    bool myTurn = true;
    ////TODO: Corrigir aqui dps
    // If the capture index is null, it means the movement is mine
//     if (captureIndex == null) {
//       myTurn = false;

//       captureIndex = state.availableDestinations
//           .firstWhere((d) => d.destination == destinationIndex)
//           .captu
// re;
//       _client.movement(
//         sourceIndex: sourceIndex,
//         captureIndex: captureIndex,
//         destinationIndex: destinationIndex,
//       );
//     }

    ////TODO: Corrigir aqui dps
    // state.board[sourceIndex] = state.board[sourceIndex].switchEmpty();
    // state.board[destinationIndex] = state.board[destinationIndex].switchEmpty();
    // state.board[captureIndex] = state.board[captureIndex].switchEmpty();

    bool gameOver = isGameOver(state.board);

    return GameState(
      selectedIndex: -1,
      soundEnable: state.soundEnable,
      board: state.board,
      availableDestinations: [],
      messages: state.messages,
      unreadMessagesCount: state.unreadMessagesCount,
      myTurn: myTurn,
      myValue: state.myValue,
      gameOver: gameOver,
      whiteFlag: state.whiteFlag,
      firstPlayer: state.firstPlayer,
      secondPlayer: state.secondPlayer,
    );
  }
}
