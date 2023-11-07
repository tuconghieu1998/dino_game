import 'package:dino_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

const double GRAVITY = 1000;

class Dino extends SpriteAnimationComponent {
  SpriteAnimation? _idleAnimation;
  SpriteAnimation? _runAnimation;
  SpriteAnimation? _hitAnimation;

  double speedY = 0.0;
  double yMax = 0.0;

  Timer? _timer;
  bool _isHit = false;

  Dino() : super() {
    init();
  }

  void init() async {
    width = 80;
    height = 80;
    // 0-3: idle
    // 4-10: run
    // 11-13: kick
    // 14-16: hit
    // 17-23: sprint
    var image = await Flame.images.load("DinoSprites - tard.png");
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(24, 24));
    _idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 3);
    _runAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 10);
    _hitAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 14, to: 16);
    animation = _runAnimation;
    _isHit = false;
    _timer = Timer(2, onTick: () {
      run();
    });
  }

  void setPosition(Vector2 vector) {
    x = vector.x;
    y = vector.y;
  }

  void run() {
    _isHit = false;
    animation = _runAnimation;
  }

  void hit() {
    if (!_isHit) {
      animation = _hitAnimation;
      _timer?.start();
      _isHit = true;
    }
  }

  void idle() {
    animation = _idleAnimation;
  }

  void jump() {
    speedY = -600;
  }

  @override
  void update(double dt) {
    super.update(dt);
    speedY += GRAVITY * dt;
    y += speedY * dt;
    if (isOnGround()) {
      y = yMax;
      speedY = 0.0;
    }
    _timer?.update(dt);
  }

  bool isOnGround() {
    return y >= yMax;
  }
}
