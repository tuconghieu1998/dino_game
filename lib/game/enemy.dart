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

  EnemyData(
      {required this.imageName,
      required this.textureWidth,
      required this.textureHeight,
      required this.nColumns});
}

class Enemy extends SpriteAnimationComponent {
  double speed = 200;
  Vector2 sizeScreen = Vector2(0, 0);
  double textureWidth = 0;
  double textureHeight = 0;

  static final Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.AngryPig: EnemyData(
        imageName: "pig_walk.png",
        textureWidth: 36,
        textureHeight: 30,
        nColumns: 16),
    EnemyType.Bat: EnemyData(
        imageName: "bat_flying.png",
        textureWidth: 46,
        textureHeight: 30,
        nColumns: 7),
    EnemyType.Riho: EnemyData(
        imageName: "riho_run.png",
        textureWidth: 52,
        textureHeight: 34,
        nColumns: 6),
  };

  Enemy(EnemyType enemyType) : super() {
    init(enemyType);
  }

  void init(EnemyType enemyType) async {
    final enemyData = _enemyDetails[enemyType];
    textureWidth = enemyData!.textureWidth;
    textureHeight = enemyData.textureHeight;
    width = 80 / enemyData.textureHeight * enemyData.textureWidth;
    height = 80;
    var image = await Flame.images.load(enemyData.imageName);
    final spriteSheet = SpriteSheet(
        image: image,
        srcSize: Vector2(enemyData.textureWidth, enemyData.textureHeight));
    animation = spriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: enemyData.nColumns - 1);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    x = size[0] + width;
    y = size[1] - MyGame.groundHeight - height / 2 - 3;
    sizeScreen = size;
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;
    if (x < -width) {
      x = sizeScreen[0] + width;
    }
  }
}
