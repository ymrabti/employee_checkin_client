import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class EmployeeChecksHomeScreen extends StatelessWidget {
  static const String route = '/home';
  const EmployeeChecksHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeeChecksScaffold(
    appBar: AppBar(
        titleTextStyle: context.theme.primaryTextTheme.titleMedium,
        title: Text('${context.tr.title} - ${context.watch<EmployeeChecksState>().user?.user.name ?? ''}'),
        actions: <Widget>[IconSettings()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(context.watch<EmployeeChecksState>().user?.user.name ?? ''),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                EmployeeChecksAuthService.logOut(context);
              },
              child: Text(context.tr.logout),
            ),
          ],
        ),
      ),
    );
  }
}
