import 'dart:io';

import 'package:employee_checks/lib.dart';
import 'package:get/get.dart' hide Response;

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
      (Duration timeStamp) async {
        await _refreshUser(context);
        Get.offAllNamed(widget.user == null ? EmployeeChecksLoginPage.route : EmployeeChecksHomeScreen.route);
      },
    );
  }

  Future<void> _refreshUser(BuildContext context) async {
    EmployeeChecksUser? userBefore = widget.user;
    if (userBefore == null) return;
    AuthorizationTokens? newTokens = await EmployeeChecksAuthService().refreshToken(userBefore.tokens);
    if (newTokens == null) return;

    EmployeeChecksUser newUser = userBefore.copyWith(tokens: newTokens);

    EmployeeChecksService citizenService = EmployeeChecksService(context: context, auth: newUser.tokens);
    AuthorizationUser? pers = await citizenService.getEmployee(username: newUser.personalInfos.username);

    if (pers == null) return;
    EmployeeChecksUser updatedUser = newUser.copyWith(personalInfos: pers);
    File file = await downloadImage(updatedUser, updatedUser.personalInfos.photoo);
    await context.setUserConnected(updatedUser.copyWith(personalInfos: updatedUser.personalInfos.copyWith(imageSavedIn: file.path)));
    context.read<EmployeeChecksRealtimeState>().updateSocket(tokens: newUser.tokens);
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
