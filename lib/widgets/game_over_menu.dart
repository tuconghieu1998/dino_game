import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  const GameOverMenu({super.key, this.score, this.onReplayPressed});

  final int? score;
  final Function? onReplayPressed;

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: Text("Main menu"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: Text("Retry"),
                    onPressed: () {
                      onReplayPressed?.call();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
