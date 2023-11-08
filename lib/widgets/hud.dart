import 'package:flutter/material.dart';

class Hud extends StatelessWidget {
  const Hud({super.key, this.onPausePressed, required this.life});

  final Function? onPausePressed;
  final ValueNotifier<int> life;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              onPausePressed?.call();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.pause,
                size: 36,
                color: Colors.white,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            builder: (BuildContext context, value, child) {
              List<Widget> list = [];
              for (int i = 0; i < 5; i++) {
                list.add(Icon(
                  (i < value) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ));
              }

              return Row(
                children: list,
              );
            },
            valueListenable: life,
          ),
        )
      ],
    );
  }
}
