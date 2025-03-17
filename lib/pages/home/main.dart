import 'dart:math';
import 'package:employee_checks/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EmployeeChecksHomeScreen extends StatefulWidget {
  static const String route = '/home';
  const EmployeeChecksHomeScreen({super.key});

  @override
  State<EmployeeChecksHomeScreen> createState() => _EmployeeChecksHomeScreenState();
}

class _EmployeeChecksHomeScreenState extends State<EmployeeChecksHomeScreen> {
  List<Widget> bodies = <Widget>[
    ScanBodyScreen(),
    Container(color: Colors.amber),
    EmployeeChecksPersonalInfos(
      initialValue: (BuildContext context) {
        AuthorizationUser? pi = context.watch<EmployeeChecksState>().user?.personalInfos;
        return pi;
      },
      onButtonTap: (BuildContext context, GlobalKey<FormBuilderState> formKey) {},
      textButton: (BuildContext context) => context.tr.update_profile,
    ),
  ];
  int bodyIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bodyIndex,
        fixedColor: context.theme.primaryColor,
        onTap: (int value) {
          bodyIndex = value;
          setState(() {});
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.qrcode_viewfinder),
            label: context.tr.scan,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.time),
            label: context.tr.my_check_history,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: context.tr.my_profile,
          ),
        ],
      ),
      body: AnimBuilder(child: bodies[bodyIndex]),
    );
  }
}

class ScanBodyScreen extends StatelessWidget {
  const ScanBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EmployeeChecksUser? user = context.watch<EmployeeChecksState>().user;
    DateTime dateTime = DateTime.now();
    return user?.personalInfos.role == EmployeeChecksUserRoles.fieldWorker.name //
        ? fieldWorkerWidget()
        : UserWidget(personalInfos: user?.personalInfos, start: dateTime);
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
          DateTime dateTime = DateTime.now();
          return AnimBuilder(
            child: (incomingQrData == null || incomingQrData.qr.isEmpty)
                ? CircularProgressIndicator.adaptive()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12.r,
                    children: <Widget>[
                      if (userScanned == null) qrShowWidget(incomingQrData, radius, borderWidth),
                      if (userScanned != null && user != null) UserWidget(start: dateTime, personalInfos: userScanned),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget qrShowWidget(IncomeingQr incomingQrData, double radius, double borderWidth) {
    return TemporalWidgetBuilder(
      duration_in_millis: incomingQrData.lifecyle_in_seconds * 1000,
      start: incomingQrData.generated,
      builder: (BuildContext context, double? value) => RectangleProgressIndicator(
        progressColor: context.theme.primaryColorDark,
        backgroundColor: context.theme.foregroundColor,
        borderRadius: radius,
        progress: value == null ? null : max(min(1, value), 0),
        borderWidth: borderWidth,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(radius + borderWidth / 2),
            ),
          ),
          margin: EdgeInsets.all(8.r),
          padding: EdgeInsets.all(12.r),
          child: QrImageView(data: incomingQrData.qr, size: 320.r),
        ),
      ),
    );
  }
}
