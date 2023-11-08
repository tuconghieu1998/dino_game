import 'dart:math';

import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class EnemyManager extends Component with HasGameRef<MyGame> {
  late Random _random;
  late Timer _timer;
  int _spawnLevel = 0;
  EnemyManager() {
    _random = Random();
    _spawnLevel = 0;
    _timer = Timer(4, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }

  void spawnRandomEnemy() {
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final randomEnemyType = EnemyType.values.elementAt(randomNumber);
    final enemy = Enemy(randomEnemyType);
    enemy.startAtPosition(gameRef.size[0] + enemy.width,
        gameRef.size[1] - MyGame.groundHeight - enemy.height / 2 - 3);
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);

    var newSpawnLevel = (gameRef.score ~/ 500);
    if (_spawnLevel < newSpawnLevel) {
      _spawnLevel = newSpawnLevel;

      var newWaitTime = (4 / (1 + (0.1 * _spawnLevel)));
      _timer.stop();
      _timer = Timer(4, repeat: true, onTick: () {
        spawnRandomEnemy();
      });
      _timer.start();
    }
  }

  void reset() {
    _spawnLevel = 0;
    _timer = Timer(4, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }
}
