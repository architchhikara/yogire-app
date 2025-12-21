import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../domain/time_phase_provider.dart';

class SunDialWidget extends StatelessWidget {
  final DayPhase phase;
  final DateTime? sunrise;
  final DateTime? sunset;
  final DateTime? bmStart;

  const SunDialWidget({
    super.key,
    required this.phase,
    this.sunrise,
    this.sunset,
    this.bmStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange.withOpacity(0.1),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Sector
          CustomPaint(
            size: const Size(200, 200),
            painter: SunDialPainter(phase: phase),
          ),
          // Center Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconForPhase(phase),
                size: 40,
                color: Colors.orange[800],
              ),
              const SizedBox(height: 8),
              Text(
                _getTextForPhase(phase),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForPhase(DayPhase phase) {
    switch (phase) {
      case DayPhase.brahmaMuhurtam:
        return Icons.spa;
      case DayPhase.sunrise:
        return Icons.wb_twilight;
      case DayPhase.day:
        return Icons.wb_sunny;
      case DayPhase.sunset:
        return Icons.wb_twilight;
      case DayPhase.night:
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  String _getTextForPhase(DayPhase phase) {
    switch (phase) {
      case DayPhase.brahmaMuhurtam:
        return "Brahma Muhurtam";
      case DayPhase.sunrise:
        return "Sunrise";
      case DayPhase.day:
        return "Day Time";
      case DayPhase.sunset:
        return "Sunset";
      case DayPhase.night:
        return "Night";
      default:
        return "Loading...";
    }
  }
}

class SunDialPainter extends CustomPainter {
  final DayPhase phase;

  SunDialPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Draw full circle background
    paint.color = Colors.orange.withOpacity(0.2); // Using withOpacity for compatibility with older flutter sdk
    canvas.drawCircle(center, radius, paint);

    // Draw active sector based on phase
    // This is a simplified visualization. A real sundial would map time to angle.
    // Here we just highlight a section.
    paint.color = Colors.orange;
    double startAngle = -math.pi / 2; // 12 o'clock
    double sweepAngle = 0;

    switch (phase) {
      case DayPhase.brahmaMuhurtam:
        startAngle = -math.pi / 2 - math.pi / 4; // Approx 3 AM position
        sweepAngle = math.pi / 6;
        break;
      case DayPhase.sunrise:
        startAngle = -math.pi / 2 + math.pi / 6; // 6 AM
        sweepAngle = math.pi / 6;
        break;
      case DayPhase.day:
        startAngle = 0;
        sweepAngle = math.pi;
        break;
      case DayPhase.sunset:
        startAngle = math.pi - math.pi / 6;
        sweepAngle = math.pi / 6;
        break;
      case DayPhase.night:
        startAngle = math.pi;
        sweepAngle = math.pi;
        break;
      default:
        break;
    }

    if (sweepAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
