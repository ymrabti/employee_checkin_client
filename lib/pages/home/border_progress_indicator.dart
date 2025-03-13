import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:employee_checks/lib.dart';

class BorderProgressIndicator extends StatefulWidget {
  /// The width of the border
  final double borderWidth;

  /// The color of the progress border
  final Color progressColor;

  /// The color of the remaining border
  final Color backgroundColor;

  /// Border radius for the container
  final double borderRadius;

  /// The child widget to display inside the container
  final Widget? child;

  /// Padding inside the container
  final EdgeInsets padding;

  /// Direction of the Progress (clockwise or counterclockwise)
  final bool clockwise;

  const BorderProgressIndicator({
    super.key,
    required this.incomeingQr,
    this.borderWidth = 2.0,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.borderRadius = 8.0,
    this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.clockwise = true,
  });

  final IncomeingQr incomeingQr;
  @override
  State<BorderProgressIndicator> createState() => _BorderProgressIndicatorState();
}

class _BorderProgressIndicatorState extends State<BorderProgressIndicator> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      Durations.short1,
      (Timer timer) {
        double? percentage = percent();
        context.read<EmployeeChecksState>().changePercent = percentage;
      },
    );
  }

  double percent() {
    Duration difference = DateTime.now().difference(widget.incomeingQr.generated);
    int inSeconds = difference.inMilliseconds;
    int lifecyle = widget.incomeingQr.lifecyle_in_seconds * 1000;
    double v = inSeconds / lifecyle;
    return 1 - v;
  }

  @override
  void dispose() {
    super /*  */ .dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double? value = context.watch<EmployeeChecksState>().percent;
    return Padding(
      padding: widget.padding,
      child: CustomPaint(
        painter: BorderProgressPainter(
          progress: max(min(1, value ?? 0), 0),
          borderWidth: widget.borderWidth,
          progressColor: widget.progressColor,
          backgroundColor: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          clockwise: widget.clockwise,
        ),
        child: widget.child,
      ),
    );
  }
}

class BorderProgressPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final Color progressColor;
  final Color backgroundColor;
  final double borderRadius;
  final bool clockwise;

  BorderProgressPainter({
    required this.progress,
    required this.borderWidth,
    required this.progressColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.clockwise,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Draw background border (full rectangle)
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, backgroundPaint);

    // Draw progress border
    if (progress > 0) {
      final Paint progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      final double totalLength = _calculatePerimeter(size);
      final double progressLength = totalLength * progress;

      _drawProgressBorder(canvas, size, progressLength, progressPaint);
    }
  }

  double _calculatePerimeter(Size size) {
    // This is an approximation for a rounded rectangle
    // For a more precise calculation, you would need to account for the curves
    return 2 * (size.width + size.height) - 2 * borderRadius * (4 - Math.pi);
  }

  void _drawProgressBorder(Canvas canvas, Size size, double progressLength, Paint paint) {
    // Create path for the entire rounded rectangle
    final Path path = Path();

    // Start from top-left if clockwise, or top-right if counterclockwise
    if (clockwise) {
      path.moveTo(borderRadius, 0);

      // Top edge
      path.lineTo(size.width - borderRadius, 0);

      // Top-right corner
      path.arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      // Right edge
      path.lineTo(size.width, size.height - borderRadius);

      // Bottom-right corner
      path.arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      // Bottom edge
      path.lineTo(borderRadius, size.height);

      // Bottom-left corner
      path.arcToPoint(
        Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      // Left edge
      path.lineTo(0, borderRadius);

      // Top-left corner
      path.arcToPoint(
        Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );
    } else {
      path.moveTo(size.width - borderRadius, 0);

      // Right side (from top-right corner, going counterclockwise)
      path.arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      path.lineTo(size.width, size.height - borderRadius);

      path.arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      path.lineTo(borderRadius, size.height);

      path.arcToPoint(
        Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      path.lineTo(0, borderRadius);

      path.arcToPoint(
        Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      path.lineTo(size.width - borderRadius, 0);
    }

    // Measure path and extract the portion corresponding to progress
    final PathMetrics pathMetrics = path.computeMetrics();
    final PathMetric pathMetric = pathMetrics.first;

    final Path progressPath = pathMetric.extractPath(0, progressLength);

    // Draw the progress path
    canvas.drawPath(progressPath, paint);
  }

  @override
  bool shouldRepaint(covariant BorderProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.borderWidth != borderWidth || oldDelegate.progressColor != progressColor || oldDelegate.backgroundColor != backgroundColor || oldDelegate.borderRadius != borderRadius || oldDelegate.clockwise != clockwise;
  }
}

// Create a Math utility class since Flutter doesn't have Math.pi directly
class Math {
  static const double pi = 3.1415926535897932;
}
