import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class RectangleProgressIndicator extends StatefulWidget {
  /// The progress value between 0.0 and 1.0, or null for indeterminate mode
  final double? progress;

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

  /// Container width (optional, expands to parent if null)
  final double? width;

  /// Container height (optional, expands to parent if null)
  final double? height;

  /// Padding inside the container
  final EdgeInsets padding;

  /// Direction of the progress (clockwise or counterclockwise)
  final bool clockwise;

  /// Animation duration for indeterminate mode
  final Duration animationDuration;

  /// How much of the border to show during indeterminate animation (0.0-1.0)
  final double indeterminateArcSize;

  const RectangleProgressIndicator({
    super.key,
    this.progress,
    this.borderWidth = 2.0,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.borderRadius = 8.0,
    this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.clockwise = true,
    this.animationDuration = const Duration(seconds: 1),
    this.indeterminateArcSize = 0.35,
  })  : assert(progress == null || (progress >= 0.0 && progress <= 1.0)),
        assert(indeterminateArcSize > 0.0 && indeterminateArcSize <= 1.0);

  @override
  State<RectangleProgressIndicator> createState() => _BorderProgressIndicatorState();
}

class _BorderProgressIndicatorState extends State<RectangleProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    if (widget.progress == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RectangleProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.progress == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.progress != null && _controller.isAnimating) {
      _controller.stop();
    }

    if (widget.animationDuration != oldWidget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: widget.progress == null
          ? AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: RectangleProgressPainter(
                    progress: widget.indeterminateArcSize,
                    startAngle: _controller.value * 2 * math.pi,
                    borderWidth: widget.borderWidth,
                    progressColor: widget.progressColor,
                    backgroundColor: widget.backgroundColor,
                    borderRadius: widget.borderRadius,
                    clockwise: widget.clockwise,
                    isIndeterminate: true,
                  ),
                  child: widget.child,
                );
              },
            )
          : CustomPaint(
              painter: RectangleProgressPainter(
                progress: widget.progress!,
                borderWidth: widget.borderWidth,
                progressColor: widget.progressColor,
                backgroundColor: widget.backgroundColor,
                borderRadius: widget.borderRadius,
                clockwise: widget.clockwise,
                isIndeterminate: false,
              ),
              child: widget.child,
            ),
    );
  }
}

class RectangleProgressPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final Color progressColor;
  final Color backgroundColor;
  final double borderRadius;
  final bool clockwise;
  final bool isIndeterminate;
  final double startAngle;

  RectangleProgressPainter({
    required this.progress,
    this.startAngle = 0.0,
    required this.borderWidth,
    required this.progressColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.clockwise,
    required this.isIndeterminate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(borderWidth / 2, borderWidth / 2, size.width - borderWidth, size.height - borderWidth);

    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Draw background border (full rectangle)
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rrect, backgroundPaint);

    // Draw progress border
    if (progress > 0) {
      final Paint progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeCap = StrokeCap.round;

      if (isIndeterminate) {
        _drawIndeterminateProgress(canvas, size, progressPaint);
      } else {
        final double totalLength = _calculatePerimeter(size);
        final double progressLength = totalLength * progress;
        _drawProgressBorder(canvas, size, progressLength, progressPaint);
      }
    }
  }

  double _calculatePerimeter(Size size) {
    // Adjusted for the borderWidth offset
    final double width = size.width - borderWidth;
    final double height = size.height - borderWidth;
    // Approximation for a rounded rectangle perimeter
    return 2 * (width + height) - 8 * borderRadius + 2 * math.pi * borderRadius;
  }

  void _drawProgressBorder(Canvas canvas, Size size, double progressLength, Paint paint) {
    // Create path for the entire rounded rectangle
    final Path path = Path();
    final double adjustedWidth = size.width - borderWidth;
    final double adjustedHeight = size.height - borderWidth;

    // Start from top-left if clockwise, or top-right if counterclockwise
    final double startX = clockwise ? borderRadius + borderWidth / 2 : adjustedWidth - borderRadius + borderWidth / 2;
    final double startY = borderWidth / 2;

    path.moveTo(startX, startY);

    if (clockwise) {
      // Top edge
      path.lineTo(adjustedWidth - borderRadius + borderWidth / 2, startY);

      // Top-right corner
      path.arcToPoint(
        Offset(adjustedWidth + borderWidth / 2, borderRadius + borderWidth / 2),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      // Right edge
      path.lineTo(adjustedWidth + borderWidth / 2, adjustedHeight - borderRadius + borderWidth / 2);

      // Bottom-right corner
      path.arcToPoint(
        Offset(adjustedWidth - borderRadius + borderWidth / 2, adjustedHeight + borderWidth / 2),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      // Bottom edge
      path.lineTo(borderRadius + borderWidth / 2, adjustedHeight + borderWidth / 2);

      // Bottom-left corner
      path.arcToPoint(
        Offset(borderWidth / 2, adjustedHeight - borderRadius + borderWidth / 2),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );

      // Left edge
      path.lineTo(borderWidth / 2, borderRadius + borderWidth / 2);

      // Top-left corner
      path.arcToPoint(
        Offset(borderRadius + borderWidth / 2, borderWidth / 2),
        radius: Radius.circular(borderRadius),
        clockwise: true,
      );
    } else {
      // Counterclockwise path direction
      // Code for counterclockwise path (if needed)
      // Note: Implementing the counterclockwise path would be very similar with reversed direction
    }

    // Measure path and extract the portion corresponding to progress
    final PathMetrics pathMetrics = path.computeMetrics();
    final PathMetric pathMetric = pathMetrics.first;

    final Path progressPath = pathMetric.extractPath(0, progressLength);

    // Draw the progress path
    canvas.drawPath(progressPath, paint);
  }

  void _drawIndeterminateProgress(Canvas canvas, Size size, Paint paint) {
    final double totalLength = _calculatePerimeter(size);
    final double arcLength = totalLength * progress;
    final double adjustedWidth = size.width - borderWidth;
    final double adjustedHeight = size.height - borderWidth;

    // Create the full path
    final Path fullPath = Path();

    // Top edge starting point
    fullPath.moveTo(borderRadius + borderWidth / 2, borderWidth / 2);

    // Top edge
    fullPath.lineTo(adjustedWidth - borderRadius + borderWidth / 2, borderWidth / 2);

    // Top-right corner
    fullPath.arcToPoint(
      Offset(adjustedWidth + borderWidth / 2, borderRadius + borderWidth / 2),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Right edge
    fullPath.lineTo(adjustedWidth + borderWidth / 2, adjustedHeight - borderRadius + borderWidth / 2);

    // Bottom-right corner
    fullPath.arcToPoint(
      Offset(adjustedWidth - borderRadius + borderWidth / 2, adjustedHeight + borderWidth / 2),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Bottom edge
    fullPath.lineTo(borderRadius + borderWidth / 2, adjustedHeight + borderWidth / 2);

    // Bottom-left corner
    fullPath.arcToPoint(
      Offset(borderWidth / 2, adjustedHeight - borderRadius + borderWidth / 2),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Left edge
    fullPath.lineTo(borderWidth / 2, borderRadius + borderWidth / 2);

    // Top-left corner
    fullPath.arcToPoint(
      Offset(borderRadius + borderWidth / 2, borderWidth / 2),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    // Measure path and extract the rotating portion
    final PathMetrics pathMetrics = fullPath.computeMetrics();
    final PathMetric pathMetric = pathMetrics.first;

    // Calculate start position based on animation
    final double startDistance = (startAngle / (2 * math.pi)) * totalLength;

    // Handle wrap-around case
    double effectiveStart = startDistance % totalLength;
    double effectiveEnd = effectiveStart + arcLength;

    if (effectiveEnd > totalLength) {
      // Draw the part that wraps around
      final Path firstPart = pathMetric.extractPath(effectiveStart, totalLength);
      final Path secondPart = pathMetric.extractPath(0, effectiveEnd - totalLength);

      canvas.drawPath(firstPart, paint);
      canvas.drawPath(secondPart, paint);
    } else {
      // Normal case - no wrap around
      final Path arcPath = pathMetric.extractPath(effectiveStart, effectiveEnd);
      canvas.drawPath(arcPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RectangleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.startAngle != startAngle || oldDelegate.borderWidth != borderWidth || oldDelegate.progressColor != progressColor || oldDelegate.backgroundColor != backgroundColor || oldDelegate.borderRadius != borderRadius || oldDelegate.clockwise != clockwise || oldDelegate.isIndeterminate != isIndeterminate;
  }
}
