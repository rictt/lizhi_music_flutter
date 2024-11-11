
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/provider/global_provider.dart';
import 'package:lizhi_music_flutter/utils/event.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class SongPlayer {
  static late AudioPlayer? audioPlayer;
  static String currentSongUrl = "";

  SongPlayer._();
  static init() async {
    audioPlayer = AudioPlayer();
    // audioPlayer!.setReleaseMode(ReleaseMode.stop);
    audioPlayer!.onDurationChanged.listen(onDurationChanged);
    audioPlayer!.onPlayerStateChanged.listen(onPlayerStateChanged);
  }

  static onDurationChanged(Duration event) {
    print("onDurationChanged $event");
  }
  static onPlayerStateChanged(PlayerState state) {
    print("onPlayerStateChanged $state");
    if (state == PlayerState.playing) {
      eventBus.fire(SongPlayingStateChange(SongState.playing));
    } else if (state == PlayerState.paused || state == PlayerState.stopped) {
      eventBus.fire(SongPlayingStateChange(SongState.stopped));
    } else if (state == PlayerState.completed) {
      eventBus.fire(SongPlayingStateChange(SongState.stopped));
    }
  }

  static play(String url) async {
    if (url == currentSongUrl || audioPlayer == null) {
      return;
    }
    try {
      eventBus.fire(SongPlayingStateChange(SongState.buffering));
      currentSongUrl = url;
      // 因为包含中文或者空格，都会导致播放闪退
      String encodedUrl = Uri.encodeFull(url);
      String cacheFilePath = await _getCacheFilePath(url);
      if (await File(cacheFilePath).exists()) {
        print("use cache");
        audioPlayer!.play(DeviceFileSource(cacheFilePath));
      } else {
        print("download and play");
        audioPlayer!.play(UrlSource(encodedUrl));
        _downloadAndCacheAudio(url, cacheFilePath);
      }
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static paused() {
    if (audioPlayer != null) {
      audioPlayer!.pause();
    }
  }

  static Future<String> _getCacheFilePath(String url) async {
    final Directory cacheDir = await getApplicationDocumentsDirectory();
    final String fileName = Uri.parse(url).pathSegments.last;
    return '${cacheDir.path}/$fileName';
  }

  static Future<void> _downloadAndCacheAudio(String url, String cacheFilePath) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final File cacheFile = File(cacheFilePath);
      await cacheFile.writeAsBytes(response.bodyBytes);
      print("download $url success");
    } else {
      throw Exception('Failed to download audio,  Status code: ${response.statusCode}');
    }
  }
}