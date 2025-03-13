import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class EmployeeChecksHomeScreen extends StatelessWidget {
  static const String route = '/home';
  const EmployeeChecksHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthorizationUser? personalInfos = context.watch<EmployeeChecksState>().user?.personalInfos;
    String url = '${EmployeeChecksAuthService().apiUrl}/Employees/photo/${personalInfos?.username}';
    logg(url);
    return EmployeeChecksScaffold(
      appBar: AppBar(
        titleTextStyle: context.theme.primaryTextTheme.titleMedium,
        title: Text('${context.tr.title} - ${personalInfos?.firstName ?? ''}'),
        actions: <Widget>[IconSettings()],
      ),
      body: Center(
        child: Column(
          spacing: 12.r,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(child: ImagedNetwork(url: url)),
            Text(personalInfos?.firstName ?? ''),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                EmployeeChecksAuthService().logOut(context);
              },
              child: Text(context.tr.logout),
            ),
          ],
        ),
      ),
    );
  }
}
