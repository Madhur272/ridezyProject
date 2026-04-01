import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {

  static late IO.Socket socket;
  static bool isConnected = false;

  static void connect() {

    if (isConnected) return;

    socket = IO.io(
      "http://192.168.1.13:4011",
      IO.OptionBuilder()
          .setTransports(['websocket']) // force websocket
          .enableAutoConnect()
          .build()
    );

    socket.connect();
    
    socket.onConnect((_) {
      print("✅ Socket Connected");
      isConnected = true;
    });

    socket.onDisconnect((_) {
      print("❌ Socket Disconnected");
      isConnected = false;
    });

    socket.onError((err) {
      print("Socket Error: $err");
    });

  }
}