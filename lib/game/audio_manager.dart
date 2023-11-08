import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AudioManager {
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(files);
    pref = await Hive.openBox('preferences');
    if (pref.get('bgm') == null) {
      pref.put('bgm', true);
    }
    if (pref.get('sfx') == null) {
      pref.put('sfx', true);
    }

    _bgm = ValueNotifier(pref.get('bgm'));
    _sfx = ValueNotifier(pref.get('sfx'));
  }

  late Box pref;
  late ValueNotifier<bool> _sfx;
  late ValueNotifier<bool> _bgm;

  ValueNotifier<bool> get listenableSfx => _sfx;
  ValueNotifier<bool> get listenableBgm => _bgm;

  void setSfx(bool flag) {
    _sfx.value = flag;
    pref.put('sfx', flag);
  }

  void setBgm(bool flag) {
    _bgm.value = flag;
    pref.put('bgm', flag);
  }

  void startBgm(String filename) {
    if (_bgm.value) {
      FlameAudio.bgm.play(filename, volume: 0.4);
    }
  }

  void pauseBgm() {
    if (_bgm.value) {
      FlameAudio.bgm.pause();
    }
  }

  void resumeBgm() {
    if (_bgm.value) {
      FlameAudio.bgm.resume();
    }
  }

  void stopBgm() {
    if (_bgm.value) {
      FlameAudio.bgm.stop();
    }
  }

  void playSfx(String filename) {
    if (_sfx.value) {
      FlameAudio.play(filename);
    }
  }
}
