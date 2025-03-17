import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
    required this.personalInfos,
    required this.start,
  });

  final DateTime start;

  final AuthorizationUser? personalInfos;
  @override
  Widget build(BuildContext context) {
    return TemporalWidgetBuilder(
      duration_in_millis: SHOW_SCANNED_USER_IN_MELLIS,
      start: start,
      builder: (BuildContext context, double? value) {
        EmployeeChecksUser? localUser = context.watch<EmployeeChecksState>().user;
        bool current = localUser?.personalInfos.id == personalInfos?.id;
        return Center(
          child: Column(
            spacing: 12.r,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipOval(child: personalInfos?.imageWidget),
                  if (!current)
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: value,
                      ),
                    ),
                ],
              ),
              Text(
                personalInfos?.fullName ?? '',
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
