import 'package:socket_io_client/socket_io_client.dart';
import 'package:employee_checks/lib.dart';

class EmployeeChecksRealtimeState extends ChangeNotifier {
  void updateSocket({EmployeeChecksUser? user}) {
    if (user != null && user.accessTokenValid && (socket?.disconnected ?? true)) {
      final Socket sock = RealtimeConnectivity.getSocketIO(
        user,
      );
      socket = null;
      notifyListeners();
      socket = sock;
      notifyListeners();
      socket?.connect();
      _initializeEventListeners();
      notifyListeners();
    } else {
      socket?.disconnect();
      socket?.close();
      socket?.dispose();
    }
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
      SocketListenEvents.AccountActivity,
      (dynamic data) async {
        logg(data, 'AccountActivity');
        await RealtimeConnectivity.accountActivity(data);
      },
    );
  }

  EmployeeChecksRealtimeState({this.socket}) {
    _initializeEventListeners();
  }
}

abstract class SocketListenEvents {
  static const String AccountActivity = 'AccountActivity';
  static const String DISCONNECT = 'disconnect';
  static const String CONNECT_ERROR = 'connect_error';
}
