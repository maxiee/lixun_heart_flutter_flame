import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends Game {
  static const count = 30;
  static const centerCount = 80;
  static const scalarSteps = 300;
  Offset circleCenter = const Offset(0, 0);
  final Paint paint = Paint()..color = Colors.red;
  List<double> oneCircle = [];
  List<double> centerCircle = [];
  late Offset center;
  late Random random;
  int scalarStep = 0;
  int scalarFlag = 1;

  @override
  Future<void>? onLoad() {
    super.onLoad();
    center = Offset(size.x / 2, size.y / 2);
    random = Random();
    for (int i = 0; i < count; i++) {
      oneCircle.add(2 * pi / count * i);
    }
    for (int i = 0; i < centerCount; i++) {
      centerCircle.add(2 * pi / centerCount * i);
    }
  }

  Offset? heart(double t, Offset center, {double scalar = 1}) {
    double x = 16.0 * pow(sin(t), 3);
    double y = 13.0 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t);

    if (x.abs() < scalar * 0.05) return null;
    return Offset(center.dx + x * scalar, center.dy + -y * scalar);
  }

  double randomFromRange(double lower, double higher) {
    return lower + (higher - lower).abs() * random.nextDouble();
  }

  @override
  void render(Canvas canvas) {
    scalarStep += scalarFlag;
    if (scalarStep >= scalarSteps) scalarFlag *= -1;
    if (scalarStep <= 0) scalarFlag *= -1;
    for (var p in centerCircle) {
      Offset? offset = heart(p, center,
          scalar: 20.0 + 10 * sin(2 * pi / scalarSteps * scalarStep));
      if (offset == null) continue;
      canvas.drawCircle(
          Offset(
              randomFromRange(
                  min(center.dx, offset.dx), max(center.dx, offset.dx)),
              randomFromRange(
                  min(center.dy, offset.dy), max(center.dy, offset.dy))),
          random.nextInt(20).toDouble(),
          paint);
    }
    for (var p in oneCircle) {
      Offset? offset = heart(p, center,
          scalar: 20.0 + 10 * sin(2 * pi / scalarSteps * scalarStep));
      if (offset == null) continue;
      canvas.drawCircle(
          Offset(offset.dx + randomFromRange(-10, 10),
              offset.dy + randomFromRange(-10, 10)),
          random.nextInt(20).toDouble(),
          paint);
    }
  }

  @override
  void update(double dt) {
    // circleCenter = circleCenter.translate(-1, -1);
  }
}
