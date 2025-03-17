import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:employee_checks/lib.dart';

class EmployeeChecksRealtimeState extends ChangeNotifier {
  void updateSocket({EmployeeChecksUser? user}) {
    AuthorizationTokens? tokens = user?.tokens;
    if (user == null || tokens == null) {
      disconnectSocket();
      return;
    }
    if (tokens.accessTokenValid || (socket?.disconnected ?? true)) {
      final Socket sock = RealtimeConnectivity.getSocketIO(user);
      socket = null;
      notifyListeners();
      socket = sock;
      notifyListeners();
      socket?.connect();
      _initializeEventListeners();
      notifyListeners();
    } else {
      disconnectSocket();
    }
  }

  void disconnectSocket() {
    socket?.disconnect();
    socket?.close();
    socket?.dispose();
  }

  Color buttonColor = Colors.transparent;

  Socket? socket;

  void _initializeEventListeners() {
    socket?.onConnect((_) {
      logg('Connected to SocketIO', 'onConnect');
      buttonColor = Colors.green;
      notifyListeners();
    });
    socket?.onDisconnect((_) async {
      buttonColor = Colors.transparent;
      notifyListeners();
    });
    socket?.onError((_) {
      buttonColor = Colors.red;
      notifyListeners();
    });
    socket?.onConnectError((_) {
      buttonColor = Colors.yellow;
      notifyListeners();
    });
    socket?.onReconnectAttempt((_) async {
      /* AuthorizationUser? user = Get.context?.read<AppState>().userConnected;
      await Get.context?.read<AppState>().refreshTokens(user?.auth);
      AuthorizationUser? userPost = Get.context?.read<AppState>().userConnected;
      updateSocket(auth: userPost?.auth); */
      buttonColor = Colors.yellow;
      notifyListeners();
    });
    socket?.on(
      SocketListenEvents.QR_STREAM,
      (Object? message) async {
        if (message == null) return;
        Get.context?.read<EmployeeChecksState>().incomingQr = IncomeingQr.fromJson(message as Map<String, Object?>);
      },
    );
    socket?.on(
      SocketListenEvents.QR_SCANNE,
      (Object? message) async {
        if (message == null) return;
        AuthorizationUser userScanned = AuthorizationUser.fromJson(message as Map<String, Object?>);
        Get.context?.read<EmployeeChecksState>().incomingUserScan = userScanned;
      },
    );
  }

  EmployeeChecksRealtimeState({this.socket}) {
    _initializeEventListeners();
  }
}

abstract class SocketListenEvents {
  static const String QR_STREAM = 'QR_STREAM';
  static const String QR_SCANNE = 'QR_SCANNE';
  static const String DISCONNECT = 'disconnect';
  static const String CONNECT_ERROR = 'connect_error';
}
