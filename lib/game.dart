import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'dart:math' as math;

import 'package:flame/sprite.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class MyGame extends FlameGame with TapCallbacks {
  late SpriteAnimationComponent _dino;
  late ParallaxComponent _parallaxComponent;

  @override
  Future<void> onLoad() async {
    // 0-3: idle
    // 4-10: run
    // 11-13: kick
    // 14-16: hit
    // 17-23: sprint

    _dino = SpriteAnimationComponent();
    var image = await images.load("DinoSprites - tard.png");
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(24, 24));
    final idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 3);
    final runAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 10);
    _dino.animation = runAnimation;
    _dino.width = 80;
    _dino.height = 80;
    add(_dino);

    _parallaxComponent = await loadParallaxComponent([
      ParallaxImageData("parallax/plx-1.png"),
      ParallaxImageData("parallax/plx-2.png"),
      ParallaxImageData("parallax/plx-3.png"),
      ParallaxImageData("parallax/plx-4.png"),
      ParallaxImageData("parallax/plx-5.png"),
    ]);
    add(_parallaxComponent);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      // add(Square(touchPoint));
      initDino(touchPoint);
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
