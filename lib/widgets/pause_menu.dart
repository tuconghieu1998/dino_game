import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key, this.onResumePressed});

  final Function? onResumePressed;

  @override
  Widget build(BuildContext context) {
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
                    onResumePressed?.call();
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
}
