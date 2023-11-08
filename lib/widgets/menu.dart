import 'package:dino_run/screens/game_play.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, this.onSettingsPressed});

  final Function? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Dino Run",
            style: TextStyle(
                fontFamily: "Audiowide", fontSize: 42, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                "Play",
                style: TextStyle(fontSize: 18),
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GamePlay()));
            },
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                "Settings",
                style: TextStyle(fontSize: 18),
              ),
            ),
            onPressed: () {
              onSettingsPressed?.call();
            },
          )
        ],
      ),
    );
  }
}
