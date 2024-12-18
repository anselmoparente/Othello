import 'dto/dto.dart';

abstract class ClientBase {
  late final String serverIp;
  late final int serverPort;
  late final String userName;

  Stream<Dto> get dataStream;

  Future<void> initialize(String userName);

  void connectToRemoteServer(
    String ip,
    int port, {
    bool initGame = true,
    void Function(dynamic)? onError,
  });

  void startGame();

  void accept(Dto dto);

  void decline(Dto dto);

  void exit();

  void chat(String message);

  void whiteFlag();

  void movement({
    required int value,
    required int destinationIndex,
  });
}
