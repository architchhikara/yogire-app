import 'package:flutter/material.dart';

class SadhanaTreeWidget extends StatelessWidget {
  final int streakDays;

  const SadhanaTreeWidget({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: CustomPaint(
            painter: _TreePainter(streakDays: streakDays),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _getStageName(streakDays),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
        ),
        Text(
          "$streakDays Day Streak",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _getStageName(int days) {
    if (days < 7) return "Seed";
    if (days < 21) return "Sprout";
    if (days < 48) return "Sapling";
    return "Mighty Tree";
  }
}

class _TreePainter extends CustomPainter {
  final int streakDays;

  _TreePainter({required this.streakDays});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final bottomY = size.height - 10;

    // Draw Soil
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(centerX, bottomY), width: 100, height: 30),
        0,
        3.14,
        false,
        paint..color = Colors.brown[300]!);

    if (streakDays < 7) {
      // Seed
      paint.color = Colors.brown[800]!;
      canvas.drawCircle(Offset(centerX, bottomY - 5), 8, paint);
    } else if (streakDays < 21) {
      // Sprout
      paint.color = Colors.green;
      paint.strokeWidth = 4;
      paint.style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(centerX, bottomY);
      path.quadraticBezierTo(centerX, bottomY - 30, centerX + 10, bottomY - 40);
      canvas.drawPath(path, paint);

      // Leaf
      paint.style = PaintingStyle.fill;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(centerX + 12, bottomY - 42), width: 15, height: 8),
          paint);
    } else if (streakDays < 48) {
      // Sapling
      paint.color = Colors.green[700]!;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 6;

      final trunk = Path();
      trunk.moveTo(centerX, bottomY);
      trunk.lineTo(centerX, bottomY - 60);
      canvas.drawPath(trunk, paint);

      // Leaves
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, bottomY - 70), 20, paint);
      canvas.drawCircle(Offset(centerX - 15, bottomY - 55), 15, paint);
      canvas.drawCircle(Offset(centerX + 15, bottomY - 55), 15, paint);
    } else {
      // Tree
      paint.color = Colors.brown[800]!;
      paint.style = PaintingStyle.fill;

      // Trunk
      final trunkPath = Path();
      trunkPath.moveTo(centerX - 10, bottomY);
      trunkPath.lineTo(centerX + 10, bottomY);
      trunkPath.lineTo(centerX + 5, bottomY - 80);
      trunkPath.lineTo(centerX - 5, bottomY - 80);
      trunkPath.close();
      canvas.drawPath(trunkPath, paint);

      // Canopy
      paint.color = Colors.green[800]!;
      canvas.drawCircle(Offset(centerX, bottomY - 100), 40, paint);
      canvas.drawCircle(Offset(centerX - 30, bottomY - 80), 30, paint);
      canvas.drawCircle(Offset(centerX + 30, bottomY - 80), 30, paint);
      canvas.drawCircle(Offset(centerX, bottomY - 60), 30, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) {
    return oldDelegate.streakDays != streakDays;
  }
}
