import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EmployeeChecksHomeScreen extends StatelessWidget {
  static const String route = '/home';
  const EmployeeChecksHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EmployeeChecksUser? user = context.watch<EmployeeChecksState>().user;
    return EmployeeChecksScaffold(
      body: Stack(
        children: <Widget>[
          user?.personalInfos.role == 'fieldWorker'
              ? //
              fieldWorkerWidget()
              : userWidget(context.watch<EmployeeChecksState>().user),
          Positioned(
            bottom: 12.r,
            left: 0,
            right: 0,
            child: FilledButton(
              onPressed: () {
                context.logOut();
              },
              child: Text(context.tr.logout),
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldWorkerWidget() {
    return Center(
      child: Builder(
        builder: (BuildContext context) {
          EmployeeChecksUser? user = context.watch<EmployeeChecksState>().user;
          IncomeingQr? incomingQrData = context.watch<EmployeeChecksState>().qr;
          AuthorizationUser? userScanned = context.watch<EmployeeChecksState>().userScanned;
          double radius = 12.r;
          return AnimatedSwitcher(
            duration: Durations.medium2,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: (incomingQrData == null || incomingQrData.qr.isEmpty)
                ? CircularProgressIndicator.adaptive()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12.r,
                    children: <Widget>[
                      if (userScanned == null)
                        BorderProgressIndicator(
                          progressColor: context.theme.colorScheme.secondary,
                          backgroundColor: context.theme.foregroundColor,
                          incomeingQr: incomingQrData,
                          borderRadius: radius,
                          borderWidth: 5.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(radius)),
                            ),
                            margin: EdgeInsets.all(8.r),
                            padding: EdgeInsets.all(12.r),
                            child: QrImageView(data: incomingQrData.qr, size: 320.r),
                          ),
                        ),
                      //   if (userScanned == null) _WaiterToResend(),
                      if (userScanned != null) userWidget(EmployeeChecksUser(personalInfos: userScanned, tokens: user!.tokens)),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget userWidget(EmployeeChecksUser? user) {
    return Builder(
      builder: (BuildContext context) {
        return Center(
          child: Column(
            spacing: 12.r,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipOval(child: user?.imageWidget),
              Text(user?.fullName ?? ''),
              FilledButton(
                onPressed: () {
                  Get.toNamed(QRScanView.route);
                },
                child: Text(context.tr.scan_qr_now),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WaiterToResend extends StatefulWidget {
  const _WaiterToResend();
  @override
  State<_WaiterToResend> createState() => _WaiterToResendState();
}

class _WaiterToResendState extends State<_WaiterToResend> {
  @override
  Widget build(BuildContext context) {
    double? value = context.watch<EmployeeChecksState>().percent;
    return Column(
      spacing: 12.r,
      children: <Widget>[
        // CircularProgressIndicator(strokeWidth: 8.r, value: value),
        SizedBox(height: 45.r),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 68.0.r),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            value: value,
          ),
        ),
      ],
    );
  }
}
