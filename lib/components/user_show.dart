import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({
    super.key,
    required this.personalInfos,
    required this.start,
    required this.autoBack,
    this.columnView = true,
  });
  final DateTime start;
  final bool autoBack;
  final bool columnView;
  final AuthorizationUser? personalInfos;

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration timeStamp) {
        Future<void>.delayed(
          Duration(milliseconds: SHOW_SCANNED_USER_IN_MELLIS),
          () {
            if (widget.autoBack) {
              Get.back();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TemporalWidgetBuilder(
      duration_in_millis: SHOW_SCANNED_USER_IN_MELLIS,
      start: widget.start,
      builder: (BuildContext context, double? value) {
        EmployeeChecksUser? localUser = context.watch<EmployeeChecksState>().user;
        bool current = localUser?.personalInfos.id == widget.personalInfos?.id;
        return Center(
          child: Column(
            spacing: 12.r,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.columnView)
                Column(
                  spacing: 18.r,
                  children: photoFullname(context, current, value),
                )
              else
                Row(
                  spacing: 18.r,
                  children: photoFullname(context, current, value),
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

  List<Widget> photoFullname(BuildContext context, bool current, double? value) => <Widget>[
        Stack(
          children: <Widget>[
            ClipOval(child: widget.personalInfos?.imageWidget),
            if (!current)
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: value,
                ),
              ),
          ],
        ),
        Text(
          widget.personalInfos?.fullName ?? '',
          style: context.theme.primaryTextTheme.titleLarge,
        ),
      ];
}
