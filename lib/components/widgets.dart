import 'package:employee_checks/lib.dart';

class CustomThemeSwitchingArea extends StatelessWidget {
  CustomThemeSwitchingArea({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (BuildContext context) => child,
      ),
    );
  }
}

class EmployeeChecksWaiter extends StatelessWidget {
  const EmployeeChecksWaiter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180.r,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Image.asset(
            'src/logo-animated.gif',
          ),
        ),
      ),
    );
  }
}
class EmployeeChecksScaffold extends StatelessWidget {
  const EmployeeChecksScaffold({super.key,
   this.body,
   this.appBar,
   this.backgroundColor
   });
final Widget? body;
final PreferredSizeWidget? appBar;
final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    bool loading = context.select((EmployeeChecksState state) => state.loading);
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: loading ? EmployeeChecksWaiter() : body,
    );
  }
}
