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
    List<AuthorizationUser> usersScanned = context.watch<EmployeeChecksState>().usersScannedTemp;
    DateTime dateTime = DateTime.now();
    return user?.personalInfos.role == EmployeeChecksUserRoles.fieldWorker.name //
        ? EmployeeChecksResponsiveWidget(
            builder: (bool isPortrait, Animation<double> fa, Animation<Offset> sa) {
              return SlideFadeTransition(
                fadeAnimation: fa,
                slideAnimation: sa,
                child: fieldWorkerWidget(),
              );
            },
            medium: (Animation<double> fa, Animation<Offset> sa) {
              return Row(
                children: <Widget>[
                  SlideFadeTransition(
                    fadeAnimation: fa,
                    slideAnimation: sa,
                    child: fieldWorkerWidget(false),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for (AuthorizationUser e in usersScanned) _item(e),
                        ],
                      ),
                    ),
                  ),
                  /* Expanded(
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: AnimatedList(
                        primary: true,
                        initialItemCount: usersScanned.length,
                        itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                          AuthorizationUser e = usersScanned.elementAt(index);
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: _item(e),
                          );
                        },
                      ),
                    ),
                  ), */
                ],
              );
            },
          )
        : UserWidget(personalInfos: user?.personalInfos, start: dateTime, autoBack: false);
  }

  Widget _item(AuthorizationUser e) {
    return Builder(
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        return Container(
          constraints: BoxConstraints(maxWidth: 450),
          margin: EdgeInsets.all(12.0.r),
          decoration: BoxDecoration(
            color: context.theme.backgroundColor.contrast(20),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: <BoxShadow>[
              BoxShadow(
                spreadRadius: .5,
                blurRadius: 6,
                color: context.theme.foregroundColor.withValues(alpha: 128),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.r),
          child: Column(
            spacing: 18.r,
            children: <Widget>[
              UserWidget(
                personalInfos: e,
                start: now,
                autoBack: false,
                columnView: false,
              ),
              Text(e.fullName),
              Text(e.email),
            ],
          ),
        );
      },
    );
  }

  Widget fieldWorkerWidget([bool isSmall = true]) {
    return Center(
      child: Builder(
        builder: (BuildContext context) {
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
                      if (!isSmall || userScanned == null)
                        qrShowWidget(incomingQrData, radius, borderWidth)
                      else
                        UserWidget(
                          start: dateTime,
                          personalInfos: userScanned,
                          autoBack: false,
                        ),
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
