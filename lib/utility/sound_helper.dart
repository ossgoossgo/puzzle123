import 'dart:math';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundHelper {
  static SoundHelper? instance;
  late int? gamepassSoundId;
  late int? boSoundId;
  late int? cancelSoundId;
  late int? startSoundId;
  late int? loseSoundId;
  late int? winSoundId;
  late int? pauseSoundId;
  late int? resumeSoundId;
  late int? clickSoundId;
  late Soundpool soundPool;

  static Future<void> init() async {
    if (instance == null) {
      instance = SoundHelper();
      instance!.soundPool = Soundpool.fromOptions(options: const SoundpoolOptions(streamType: StreamType.music, maxStreams: 15));

      instance!.boSoundId = await rootBundle.load("assets/audios/bo.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.gamepassSoundId = await rootBundle.load("assets/audios/gamepass.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.cancelSoundId = await rootBundle.load("assets/audios/cancel.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.startSoundId = await rootBundle.load("assets/audios/start.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.loseSoundId = await rootBundle.load("assets/audios/lose.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.winSoundId = await rootBundle.load("assets/audios/win.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.pauseSoundId = await rootBundle.load("assets/audios/pause.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.resumeSoundId = await rootBundle.load("assets/audios/resume.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });

      instance!.clickSoundId = await rootBundle.load("assets/audios/click.mp3").then((ByteData soundData) {
        return instance!.soundPool.load(soundData);
      });
    }
  }

  static playGamepassSound({double volume = 1.0}) {
    instance!.soundPool.setVolume(soundId: instance!.gamepassSoundId!, volume: volume);
    instance!.soundPool.play(instance!.gamepassSoundId!);
  }

  static playBoSound() {
    // Random random = Random();
    // instance!.soundPool.setVolume(soundId: instance!.boSoundId!, volume: (random.nextInt(60) + 40) / 100);
    instance!.soundPool.play(instance!.boSoundId!); //rate: (random.nextInt(60) + 40) / 100
  }

  static playCancelSound({double volume = 1.0}) {
    instance!.soundPool.setVolume(soundId: instance!.cancelSoundId!, volume: volume);
    instance!.soundPool.play(instance!.cancelSoundId!);
  }

  static playStartSound({double volume = 1.0}) {
    instance!.soundPool.setVolume(soundId: instance!.startSoundId!, volume: volume);
    instance!.soundPool.play(instance!.startSoundId!);
  }

  static playLoseSound({double volume = 1.0}) {
    instance!.soundPool.setVolume(soundId: instance!.loseSoundId!, volume: volume);
    instance!.soundPool.play(instance!.loseSoundId!);
  }

  static playWinSound({double volume = 1.0}) {
    instance!.soundPool.setVolume(soundId: instance!.winSoundId!, volume: volume);
    instance!.soundPool.play(instance!.winSoundId!);
  }

  static playPauseSound({double volume = 1.0}) {
    instance!.soundPool.setVolume(soundId: instance!.pauseSoundId!, volume: volume);
    instance!.soundPool.play(instance!.pauseSoundId!);
  }

  static playResumeSound({double volume = 0.4}) {
    instance!.soundPool.setVolume(soundId: instance!.resumeSoundId!, volume: volume);
    instance!.soundPool.play(instance!.resumeSoundId!);
  }

  static playClickSound({double volume = 0.3}) {
    instance!.soundPool.setVolume(soundId: instance!.clickSoundId!, volume: volume);
    instance!.soundPool.play(instance!.clickSoundId!);
  }

  static release() {
    instance!.soundPool.release();
  }
}
