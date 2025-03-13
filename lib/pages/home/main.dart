import 'dart:async';

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
      /* appBar: AppBar(
        title: Text(
          context.watch<EmployeeChecksState>().user?.personalInfos.id ?? '',
          style: context.theme.primaryTextTheme.titleMedium,
        ),
      ), */
      body: Stack(
        children: <Widget>[
          user?.personalInfos.role == 'fieldWorker'
              ? //
              fieldWorkerWidget()
              : UserWidget(user: user, start: DateTime.now()),
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
          double borderWidth = 15.0.r;
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
                          progressColor: context.theme.primaryColorDark,
                          backgroundColor: context.theme.foregroundColor,
                          incomeingQr: incomingQrData,
                          borderRadius: radius,
                          borderWidth: borderWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(radius + borderWidth / 2),
                              ),
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: QrImageView(data: incomingQrData.qr, size: 320.r),
                          ),
                        ),
                      //   if (userScanned == null) _WaiterToResend(),
                      if (userScanned != null)
                        UserWidget(
                          start: DateTime.now(),
                          user: EmployeeChecksUser(
                            personalInfos: userScanned,
                            tokens: user!.tokens,
                          ),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class UserWidget extends StatefulWidget {
  const UserWidget({
    super.key,
    this.user,
    required this.start,
  });
  final DateTime start;
  final EmployeeChecksUser? user;

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  double? value;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    EmployeeChecksUser? localUser = context.read<EmployeeChecksState>().user;
    bool current = localUser?.personalInfos.id == widget.user?.personalInfos.id;
    if (current) return;
    _timer = Timer.periodic(
      Durations.short1,
      (Timer timer) {
        double? percentage = percent();
        value = percentage;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super /*  */ .dispose();
    _timer?.cancel();
  }

  double percent() {
    Duration difference = DateTime.now().difference(widget.start);
    int inSeconds = difference.inMilliseconds;
    double v = inSeconds / SHOW_SCANNED_USER_IN_MELLIS;
    return 1 - v;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        EmployeeChecksUser? localUser = context.watch<EmployeeChecksState>().user;
        bool current = localUser?.personalInfos.id == widget.user?.personalInfos.id;
        return Center(
          child: Column(
            spacing: 12.r,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipOval(child: widget.user?.imageWidget),
                  if (!current)
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: value,
                      ),
                    ),
                ],
              ),
              Text(
                widget.user?.fullName ?? '',
                style: context.theme.primaryTextTheme.titleLarge,
              ),
              if (current)
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

class _UnWaiterToResend extends StatefulWidget {
  const _UnWaiterToResend();
  @override
  State<_UnWaiterToResend> createState() => _UnWaiterToResendState();
}

class _UnWaiterToResendState extends State<_UnWaiterToResend> {
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
