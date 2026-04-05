import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;

  static void connect(int userId) {
    socket = IO.io(
      "http://10.0.2.2:5000",
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // ✅ allow both
          .disableAutoConnect()
          .setReconnectionAttempts(5)              // ✅ auto retry
          .setReconnectionDelay(2000)
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ Connected: ${socket!.id}");
      socket!.emit("joinRoom", userId);            // ✅ join room after connect
    });

    // ✅ Keep listeners OUTSIDE onConnect — they only need to be registered once
    socket!.on("receiveMessage", (data) {
      print("🔥 RECEIVED MESSAGE: $data");
    });

    socket!.on("conversationUpdated", (data) {
      print("🔄 CONVERSATION UPDATED: $data");
    });

    socket!.onAny((event, data) {
      print("📡 EVENT: $event | DATA: $data");
    });

    socket!.onDisconnect((_) => print("❌ Disconnected"));
    socket!.onConnectError((e) => print("❌ Connection error: $e"));
    socket!.onError((e) => print("❌ Socket error: $e"));
  }

  static void sendMessage({
    required int senderId,
    required int receiverId,
    required String message,
  }) {
    if (socket == null || !socket!.connected) {
      print("❌ Socket not connected — message not sent");
      return;
    }

    socket!.emit("sendMessage", {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
    });

    print("📤 Sent: $message to $receiverId");
  }

  static void disconnect() {
    socket?.disconnect();
    socket = null;
    print("🔌 Socket disconnected");
  }
}