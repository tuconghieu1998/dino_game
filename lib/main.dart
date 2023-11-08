import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/screens/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await AudioManager.instance
      .init(['8BitPlatformerLoop.wav', 'hurt7.wav', 'jump14.wav']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dino Run',
        theme: ThemeData(
          fontFamily: 'Audiowide',
        ),
        home: const MainMenu());
  }
}
