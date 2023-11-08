import 'dart:ffi';

import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flutter/material.dart';

import 'package:dino_run/game/dino.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/enemy_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'dart:math' as math;

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
  double _elapsedTime = 0.0;

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

    overlays.addEntry(
        'Hud',
        (context, game) => Hud(
              onPausePressed: pauseGame,
              life: _dino.life,
            ));
    overlays.addEntry(
        'PauseMenu', (context, game) => PauseMenu(onResumePressed: resumeGame));
    overlays.addEntry(
        'GameOverMenu',
        (context, game) => GameOverMenu(
              score: score,
              onReplayPressed: () {
                reset();
                overlays.remove('GameOverMenu');
                resumeEngine();
              },
            ));

    add(_parallaxComponent);
    add(_groundParallax);
    add(_dino);
    add(_enemyManager);
    add(_scoreText);
    overlays.add('Hud');
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
    _elapsedTime += dt;
    if (_elapsedTime >= (1 / 60)) {
      _elapsedTime = 0.0;
      score += 1;
      _scoreText.text = score.toString();
    }

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

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        pauseGame();
        break;
    }
  }
}
