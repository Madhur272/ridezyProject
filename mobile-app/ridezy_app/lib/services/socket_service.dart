import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {

  static late IO.Socket socket;

  static void connect() {

    socket = IO.io(
      "http://192.168.1.13:4011",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .build()
    );

    socket.onConnect((_) {
      print("Connected to server");
    });

    socket.on("vehicle_update", (data) {
      print("Live update: $data");
    });

  }

}