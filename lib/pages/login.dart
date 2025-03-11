import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class EmployeeChecksLoginPage extends StatelessWidget {
  static const String route = '/login';
  const EmployeeChecksLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeeChecksScaffold(
      appBar: AppBar(
        actions: <Widget>[IconSettings()],
        titleTextStyle: context.theme.primaryTextTheme.titleMedium,
        title: Text(context.tr.loginButtonText),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () {
            context.read<EmployeeChecksState>().load = true;
            Future<void>.delayed(
              Duration(seconds: 3),
              () {
                if (!context.mounted) return;
                context.read<EmployeeChecksState>().load = false;
                EmployeeChecksUser user = EmployeeChecksUser.random();
                context.read<EmployeeChecksState>().setUserConnected(user);
                EmployeeChecksAuthService.redirectAfterLogin();
              },
            );
          },
          child: Text(context.tr.loginButtonText),
        ),
      ),
    );
  }
}
