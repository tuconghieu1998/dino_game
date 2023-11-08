import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'game.dart';

enum EnemyType { AngryPig, Bat, Riho }

class EnemyData {
  final String imageName;
  final double textureWidth;
  final double textureHeight;
  final int nColumns;
  final bool canFly;
  final int speed;

  EnemyData(
      {required this.imageName,
      required this.textureWidth,
      required this.textureHeight,
      required this.nColumns,
      required this.canFly,
      required this.speed});
}

class Enemy extends SpriteAnimationComponent {
  late EnemyData _enemyData;
  final Random _random = Random();

  static final Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.AngryPig: EnemyData(
        imageName: "pig_walk.png",
        textureWidth: 36,
        textureHeight: 30,
        nColumns: 16,
        canFly: false,
        speed: 250),
    EnemyType.Bat: EnemyData(
        imageName: "bat_flying.png",
        textureWidth: 46,
        textureHeight: 30,
        nColumns: 7,
        canFly: true,
        speed: 300),
    EnemyType.Riho: EnemyData(
        imageName: "riho_run.png",
        textureWidth: 52,
        textureHeight: 34,
        nColumns: 6,
        canFly: false,
        speed: 350),
  };

  Enemy(EnemyType enemyType) : super() {
    init(enemyType);
  }

  void init(EnemyType enemyType) async {
    _enemyData = _enemyDetails[enemyType]!;

    width = 80 / _enemyData.textureHeight * _enemyData.textureWidth;
    height = 80;
    var image = await Flame.images.load(_enemyData.imageName);
    final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(_enemyData.textureWidth, _enemyData.textureHeight));
    animation = spriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: _enemyData.nColumns - 1);
  }

  startAtPosition(double startX, double startY) {
    x = startX;
    y = startY;

    if (_enemyData.canFly && _random.nextBool()) {
      y -= height;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= _enemyData.speed * dt;
    if (x < -width) {
      removeFromParent();
    }
  }
}
