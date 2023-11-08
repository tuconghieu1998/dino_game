import 'package:dino_run/screens/game_play.dart';
import 'package:dino_run/widgets/menu.dart';
import 'package:dino_run/widgets/settings.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late ValueNotifier<CrossFadeState> _crossFadeStateNotifier;

  @override
  void initState() {
    super.initState();
    _crossFadeStateNotifier = ValueNotifier(CrossFadeState.showFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/menu_background.png'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.black.withOpacity(0.5),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
                  child: ValueListenableBuilder(
                    valueListenable: _crossFadeStateNotifier,
                    builder: (context, value, child) {
                      return AnimatedCrossFade(
                        crossFadeState: value,
                        firstChild: Menu(
                          onSettingsPressed: showSettings,
                        ),
                        secondChild: Settings(
                          onMenuPressed: showMenu,
                        ),
                        duration: Duration(milliseconds: 300),
                      );
                    },
                  )),
            ),
          )),
    );
  }

  void showMenu() {
    _crossFadeStateNotifier.value = CrossFadeState.showFirst;
  }

  void showSettings() {
    _crossFadeStateNotifier.value = CrossFadeState.showSecond;
  }
}
