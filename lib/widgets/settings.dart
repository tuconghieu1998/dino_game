import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, this.onMenuPressed});
  final Function? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  iconSize: 32,
                  onPressed: () {
                    onMenuPressed?.call();
                  },
                  icon:
                      Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
              const SizedBox(
                width: 30,
              ),
              Text(
                "Settings",
                style: TextStyle(
                    fontFamily: "Audiowide", fontSize: 42, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          SwitchListTile(
              title: Text(
                "SFX",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              value: true,
              onChanged: (value) {}),
          SwitchListTile(
              title: Text(
                "BGM",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              value: true,
              onChanged: (value) {}),
        ],
      ),
    );
  }
}
