import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'dart:math' as math;

import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class MyGame extends FlameGame with TapCallbacks {
  late Dino _dino;
  late ParallaxComponent _parallaxComponent;
  late ParallaxComponent _groundParallax;
  late EnemyManager _enemyManager;

  static const groundHeight = 60.0;

  final TextComponent _scoreText = TextComponent(
      textRenderer: TextPaint(
          style: const TextStyle(fontFamily: 'Audiowide', fontSize: 28)));
  int score = 0;

  @override
  Future<void> onLoad() async {
    _parallaxComponent = await loadParallaxComponent([
      ParallaxImageData("parallax/plx-1.png"),
      ParallaxImageData("parallax/plx-2.png"),
      ParallaxImageData("parallax/plx-3.png"),
      ParallaxImageData("parallax/plx-4.png"),
      ParallaxImageData("parallax/plx-5.png")
    ],
        baseVelocity: Vector2(100, 0),
        velocityMultiplierDelta: Vector2(1.1, 1.0));

    _groundParallax = await loadParallaxComponent([
      ParallaxImageData("parallax/ground.png"),
    ],
        fill: LayerFill.none,
        baseVelocity: Vector2(100, 0),
        scale: Vector2(1.5, 1.5),
        position: Vector2(-200, -180));

    _dino = Dino();
    _dino.setPosition(
        Vector2(200, size[1] - _dino.height / 2 - MyGame.groundHeight));
    _dino.yMax = _dino.y;

    _enemyManager = EnemyManager();

    score = 0;
    _scoreText.text = score.toString();

    overlays.addEntry('Hud', (context, game) => _buildHud());
    overlays.addEntry('PauseMenu', (context, game) => _buildPauseMenu());
    overlays.addEntry('GameOverMenu', (context, game) => _buildGameOverMenu());

    add(_parallaxComponent);
    add(_groundParallax);
    add(_dino);
    add(_enemyManager);
    add(_scoreText);
    overlays.add('Hud');
  }

  Widget _buildHud() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              pauseGame();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.pause,
                size: 36,
                color: Colors.white,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            builder: (BuildContext context, value, child) {
              List<Widget> list = [];
              for (int i = 0; i < 5; i++) {
                list.add(Icon(
                  (i < value) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ));
              }

              return Row(
                children: list,
              );
            },
            valueListenable: _dino.life,
          ),
        )
      ],
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _scoreText.position = Vector2(size[0] / 2 - _scoreText.width / 2, 0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      // add(Square(touchPoint));
      //initDino(touchPoint);
      _dino.jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    score += (60 * dt).toInt();
    _scoreText.text = score.toString();

    children.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });

    if (_dino.life.value <= 0) {
      gameOver();
    }
  }

  void pauseGame() {
    pauseEngine();
    overlays.add('PauseMenu');
  }

  Widget _buildPauseMenu() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Paused",
                style: TextStyle(
                    fontFamily: "Audiowide", fontSize: 32, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 64,
                  onPressed: () {
                    resumeGame();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  initDino(point) async {
    final sprite = await Sprite.load('DinoSprites_tard.gif');
    final player = SpriteComponent(scale: Vector2(5, 5), sprite: sprite);
    player.anchor = Anchor.center;
    player.x = point.x;
    player.y = point.y;
    add(player);
  }

  void resumeGame() {
    overlays.remove("PauseMenu");
    resumeEngine();
  }

  _buildGameOverMenu() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Game Over",
                style: TextStyle(
                    fontFamily: "Audiowide", fontSize: 32, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your score: $score",
                style: TextStyle(
                    fontFamily: "Audiowide", fontSize: 22, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 64,
                  onPressed: () {
                    reset();
                    overlays.remove('GameOverMenu');
                    resumeEngine();
                  },
                  icon: Icon(
                    Icons.replay,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void gameOver() {
    pauseEngine();
    overlays.add('GameOverMenu');
  }

  void reset() {
    score = 0;
    _dino.reset();
    _enemyManager.reset();
    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
  }
}

class Square extends RectangleComponent with TapCallbacks {
  static const speed = 3;
  static const squareSize = 128.0;
  static const indicatorSize = 6.0;

  static final Paint red = BasicPalette.red.paint();
  static final Paint blue = BasicPalette.blue.paint();

  Square(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt;
    angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      RectangleComponent(
        size: Vector2.all(indicatorSize),
        paint: blue,
      ),
    );
    add(
      RectangleComponent(
        position: size / 2,
        size: Vector2.all(indicatorSize),
        anchor: Anchor.center,
        paint: red,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    event.handled = true;
  }
}
