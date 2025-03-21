import "package:socket_io_client/socket_io_client.dart";
import 'package:employee_checks/lib.dart';

abstract class RealtimeConnectivity {
  static Socket getSocketIO(AuthorizationTokens tokens) {
    Socket socket = io(
      '${EmployeeChecksAuthService().apiUrl}/employee_qr/',
      OptionBuilder()
          .setExtraHeaders(tokens.headers)
          .setTransports(<String>['websocket']) //
          .setReconnectionAttempts(5)
          .build(),
    );

    return socket;
  }
}
