import 'dart:math';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

// soundpool support mac/web/android
// audioplayer support windows
class SoundHelper {
  //soundpool
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
  late int? checkPointSoundId;
  late Soundpool soundPool;

  //audioplayer
  late AudioCache? audioCache;

  static Future<void> init() async {
    if (instance == null) {
      instance = SoundHelper();

      if (!Platform.isWindows) {
        //use soundpool
        instance!.soundPool = Soundpool.fromOptions(
            options: const SoundpoolOptions(
                streamType: StreamType.music, maxStreams: 15));
        instance!.boSoundId = await rootBundle
            .load("assets/audios/bo.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.gamepassSoundId = await rootBundle
            .load("assets/audios/gamepass.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.cancelSoundId = await rootBundle
            .load("assets/audios/cancel.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.startSoundId = await rootBundle
            .load("assets/audios/start.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.loseSoundId = await rootBundle
            .load("assets/audios/lose.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.winSoundId = await rootBundle
            .load("assets/audios/win.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.pauseSoundId = await rootBundle
            .load("assets/audios/pause.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.resumeSoundId = await rootBundle
            .load("assets/audios/resume.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.clickSoundId = await rootBundle
            .load("assets/audios/click.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });

        instance!.checkPointSoundId = await rootBundle
            .load("assets/audios/checkPoint.mp3")
            .then((ByteData soundData) {
          return instance!.soundPool.load(soundData);
        });
      } else {
        //audioplayers
        instance!.audioCache = AudioCache(prefix: 'assets/audios/');
        instance!.audioCache!.loadAll([
          "bo.mp3",
          "gamepass.mp3",
          "cancel.mp3",
          "start.mp3",
          "lose.mp3",
          "win.mp3",
          "pause.mp3",
          "resume.mp3",
          "click.mp3",
          "checkPoint.mp3"
        ]);
        // instance!.audioCache!.load("bo.mp3");
        // instance!.audioCache!.load("gamepass.mp3");
        // instance!.audioCache!.load("cancel.mp3");
        // instance!.audioCache!.load("start.mp3");
        // instance!.audioCache!.load("lose.mp3");
        // instance!.audioCache!.load("win.mp3");
        // instance!.audioCache!.load("pause.mp3");
        // instance!.audioCache!.load("resume.mp3");
        // instance!.audioCache!.load("click.mp3");
        // instance!.audioCache!.load("checkPoint.mp3");
      }
    }
  }

  static playGamepassSound({double volume = 1.0}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.gamepassSoundId!, volume: volume);
      instance!.soundPool.play(instance!.gamepassSoundId!);
    } else {
      instance!.audioCache!.play("gamepass.mp3", volume: volume);
    }
  }

  static playBoSound() {
    Random random = Random();
    if (!Platform.isWindows) {
      instance!.soundPool.setVolume(
          soundId: instance!.boSoundId!,
          volume: (random.nextInt(60) + 40) / 100);
      instance!.soundPool
          .play(instance!.boSoundId!); //rate: (random.nextInt(60) + 40) / 100
    } else {
      instance!.audioCache!
          .play("bo.mp3", volume: (random.nextInt(60) + 40) / 100.0);
    }
  }

  static playCancelSound({double volume = 1.0}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.cancelSoundId!, volume: volume);
      instance!.soundPool.play(instance!.cancelSoundId!);
    } else {
      instance!.audioCache!.play("cancel.mp3", volume: volume);
    }
  }

  static playStartSound({double volume = 1.0}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.startSoundId!, volume: volume);
      instance!.soundPool.play(instance!.startSoundId!);
    } else {
      instance!.audioCache!.play("start.mp3", volume: volume);
    }
  }

  static playLoseSound({double volume = 1.0}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.loseSoundId!, volume: volume);
      instance!.soundPool.play(instance!.loseSoundId!);
    } else {
      instance!.audioCache!.play("lose.mp3", volume: volume);
    }
  }

  static playWinSound({double volume = 1.0}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.winSoundId!, volume: volume);
      instance!.soundPool.play(instance!.winSoundId!);
    } else {
      instance!.audioCache!.play("win.mp3", volume: volume);
    }
  }

  static playPauseSound({double volume = 1.0}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.pauseSoundId!, volume: volume);
      instance!.soundPool.play(instance!.pauseSoundId!);
    } else {
      instance!.audioCache!.play("pause.mp3", volume: volume);
    }
  }

  static playResumeSound({double volume = 0.4}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.resumeSoundId!, volume: volume);
      instance!.soundPool.play(instance!.resumeSoundId!);
    } else {
      instance!.audioCache!.play("resume.mp3", volume: volume);
    }
  }

  static playClickSound({double volume = 0.3}) {
    if (!Platform.isWindows) {
      instance!.soundPool
          .setVolume(soundId: instance!.clickSoundId!, volume: volume);
      instance!.soundPool.play(instance!.clickSoundId!);
    } else {
      instance!.audioCache!.play("click.mp3", volume: volume);
    }
  }

  static playCheckPointSound() {
    if (!Platform.isWindows) {
      instance!.soundPool.play(instance!.checkPointSoundId!);
    } else {
      instance!.audioCache!.play("checkPoint.mp3");
    }
  }

  static release() {
    if (!Platform.isWindows) {
      instance!.soundPool.release();
    } else {
      instance!.audioCache!.clearAll();
    }
  }
}
