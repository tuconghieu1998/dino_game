import 'package:dino_run/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MyGame(),
      ),
    );
  }
}
