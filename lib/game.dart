import 'dart:ui';

import 'package:dino_run/game/dino.dart';
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

  static const groundHeight = 60.0;

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

    add(_parallaxComponent);
    add(_groundParallax);
    add(_dino);
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

  initDino(point) async {
    final sprite = await Sprite.load('DinoSprites_tard.gif');
    final player = SpriteComponent(scale: Vector2(5, 5), sprite: sprite);
    player.anchor = Anchor.center;
    player.x = point.x;
    player.y = point.y;
    add(player);
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
