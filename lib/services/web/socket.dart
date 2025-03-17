import "package:socket_io_client/socket_io_client.dart";
import 'package:employee_checks/lib.dart';

abstract class RealtimeConnectivity {
  static Socket getSocketIO(EmployeeChecksUser auth) {
    Socket socket = io(
      '${EmployeeChecksAuthService().apiUrl}/employee_qr/',
      OptionBuilder()
          .setExtraHeaders(<String, Object?>{
            'Authorization': "Bearer ${auth.tokens.access.token}",
          })
          .setTransports(<String>['websocket']) //
          .setReconnectionAttempts(5)
          .build(),
    );

    return socket;
  }
}
