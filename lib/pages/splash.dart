import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class EmployeeChecksSplashScreen extends StatefulWidget {
  static const String route = '/splash';
  const EmployeeChecksSplashScreen({
    super.key,
    this.user,
    required this.dark,
  });

  final EmployeeChecksUser? user;
  final bool dark;
  @override
  State<EmployeeChecksSplashScreen> createState() => _EmployeeChecksSplashScreenState();
}

class _EmployeeChecksSplashScreenState extends State<EmployeeChecksSplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration timeStamp) {
        Future<void>.delayed(
          Duration(seconds: 3),
          () {
            Get.offAllNamed(widget.user == null ? EmployeeChecksLoginPage.route : EmployeeChecksHomeScreen.route);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        color: widget.dark ? null : Colors.white,
        gradient: widget.dark
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  context.theme.primaryColorLight,
                  context.theme.primaryColorDark,
                ],
              )
            : null,
      ),
      child: EmployeeChecksWaiter(),
    );
  }
}
