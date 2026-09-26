import 'dart:math' as math;
import 'package:flutter/material.dart';

class DonutChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final Map<String, Color> colors;
  final double size;

  const DonutChartWidget({
    super.key,
    required this.data,
    required this.colors,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutChartPainter(data: data, colors: colors),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '100%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Map<String, Color> colors;

  _DonutChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;

    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;

    var startAngle = -math.pi / 2;

    for (final entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[entry.key] ?? Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SmoothLineChart extends StatelessWidget {
  final double height;
  final Color color;

  const SmoothLineChart({
    super.key,
    this.height = 75,
    this.color = const Color(0xFF004C8F),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SmoothLinePainter(color: color),
      ),
    );
  }
}

class _SmoothLinePainter extends CustomPainter {
  final Color color;
  _SmoothLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.60),
      Offset(size.width * 0.4, size.height * 0.55),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width, size.height * 0.20),
    ];

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, controlPoint.dx, controlPoint.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MultiLineTrendChart extends StatelessWidget {
  final double height;
  const MultiLineTrendChart({super.key, this.height = 110});

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];

    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _MultiLineTrendPainter()),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: months
              .map((m) => Text(m, style: const TextStyle(fontSize: 10, color: Colors.grey)))
              .toList(),
        ),
      ],
    );
  }
}

class _MultiLineTrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 4 series: Equity (HDFC Navy), Real Estate (green), Gold (amber), Crypto (purple)
    final series = [
      {'color': const Color(0xFF004C8F), 'y': [0.75, 0.50, 0.42, 0.35, 0.33, 0.22, 0.28, 0.25, 0.18]},
      {'color': const Color(0xFF10B981), 'y': [0.85, 0.78, 0.70, 0.65, 0.62, 0.58, 0.62, 0.60, 0.55]},
      {'color': const Color(0xFFD4AF37), 'y': [0.90, 0.84, 0.80, 0.78, 0.72, 0.75, 0.70, 0.72, 0.68]},
      {'color': const Color(0xFF7C3AED), 'y': [0.95, 0.90, 0.88, 0.85, 0.82, 0.85, 0.80, 0.78, 0.76]},
    ];

    final dxStep = size.width / 8;

    for (final s in series) {
      final color = s['color'] as Color;
      final yList = s['y'] as List<double>;

      final path = Path();
      for (int i = 0; i < yList.length; i++) {
        final x = i * dxStep;
        final y = yList[i] * size.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          final prevX = (i - 1) * dxStep;
          final prevY = yList[i - 1] * size.height;
          path.quadraticBezierTo(prevX, prevY, (prevX + x) / 2, (prevY + y) / 2);
        }
      }
      path.lineTo(size.width, yList.last * size.height);

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
