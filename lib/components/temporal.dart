import 'dart:async';
import 'package:employee_checks/lib.dart';

typedef TemporalBuilder = Widget Function(BuildContext context, double? value);

class TemporalWidgetBuilder extends StatefulWidget {
  const TemporalWidgetBuilder({
    super.key,
    required this.duration_in_millis,
    required this.start,
    this.builder,
    this.child,
  }) : assert(
          (builder != null) ^ (child != null),
          'Either builder or child must be provided, but not both.',
        );
  final Widget? child;
  final DateTime start;
  final int duration_in_millis;
  final TemporalBuilder? builder;

  @override
  State<TemporalWidgetBuilder> createState() => _TemporalWidgetBuilderState();
}

class _TemporalWidgetBuilderState extends State<TemporalWidgetBuilder> {
  double? value;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    if (widget.builder == null) return;
    _timer = Timer.periodic(
      Durations.short1,
      (Timer timer) {
        double? percentage = percent();
        value = percentage < .005 ? null : percentage;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  double percent() {
    Duration difference = DateTime.now().difference(widget.start);
    int inSeconds = difference.inMilliseconds;
    double v = inSeconds / widget.duration_in_millis;
    return 1 - v;
  }

  @override
  Widget build(BuildContext context) {
    Widget? child = widget.child;
    TemporalBuilder? builder = widget.builder;
    return child ?? builder!(context, value);
  }
}
