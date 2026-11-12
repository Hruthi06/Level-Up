import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';

double calculateAngle(
  double x1, double y1, // A (Shoulder)
  double x2, double y2, // B (Elbow / Joint Vertex)
  double x3, double y3, // C (Wrist)
) {
  final v1x = x1 - x2;
  final v1y = y1 - y2;
  final v2x = x3 - x2;
  final v2y = y3 - y2;

  final dot = (v1x * v2x) + (v1y * v2y);
  final mag1 = math.sqrt(v1x * v1x + v1y * v1y);
  final mag2 = math.sqrt(v2x * v2x + v2y * v2y);

  if (mag1 == 0 || mag2 == 0) return 0.0;

  final cosVal = (dot / (mag1 * mag2)).clamp(-1.0, 1.0);
  final radians = math.acos(cosVal);
  return radians * (180.0 / math.pi);
}

int calculateXpForLevel(int level) {
  return (100 * math.pow(level, 1.35)).round();
}

void main() {
  group('Biomechanical Angle Calculations', () {
    test('Calculates a straight 180 degree line correctly', () {
      final angle = calculateAngle(0, 0, 1, 0, 2, 0);
      expect(angle, closeTo(180.0, 0.01));
    });

    test('Calculates a perpendicular 90 degree elbow inflection angle', () {
      final angle = calculateAngle(0, 1, 0, 0, 1, 0);
      expect(angle, closeTo(90.0, 0.01));
    });

    test('Calculates acute 45 degree angle', () {
      final angle = calculateAngle(1, 1, 0, 0, 1, 0);
      expect(angle, closeTo(45.0, 0.01));
    });
  });

  group('XP & Level Progression Formula', () {
    test('Level 1 requires expected base XP', () {
      final xp = calculateXpForLevel(1);
      expect(xp, equals(100));
    });

    test('Higher levels scale quadratically with 1.35 exponent', () {
      final xpL8 = calculateXpForLevel(8);
      expect(xpL8, greaterThan(1500));
      expect(xpL8, lessThan(2000));
    });
  });
}

