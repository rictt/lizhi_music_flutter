import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/model/Album.dart';
import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:lizhi_music_flutter/utils/event.dart';
import 'package:lizhi_music_flutter/utils/prefs.dart';
import 'package:lizhi_music_flutter/utils/song_player.dart';
import 'package:lizhi_music_flutter/utils/utils.dart';

enum SongState {
  buffering,

  playing,

  paused,

  stopped,

  completed,
}

enum PlayMode {
  order,
  
  random
}

class GlobalProvider with ChangeNotifier {
  // 正在播放的歌曲、播放状态、播放时长、歌单列表
  List<Album> albumList = MusicSourceUtils.albums;
  Song? currentSong = Prefs.getCurrentSong();
  List<Song> playList = Prefs.getPlayList();
  bool isPlaying = false;
  // PlayerState state = PlayerState.stopped;
  SongState songState = SongState.stopped;
  PlayMode playMode = PlayMode.order;

  GlobalProvider() {
    eventBus.on<SongPlayingStateChange>().listen((event) {
      setSongState(event.state);
      if (event.state == SongState.completed) {
        // 播放结束，按顺序播放or结束了
        for (int i = 0; i < playList.length; i++) {
          if (playList[i].name == currentSong!.name) {
            Song song = i == playList.length - 1 ? playList.first : playList[i + 1];
            setCurrentSong(song);
            SongPlayer.play(song.songUrl);
            break;
          }
        }
      }
    });
  }
  
  setAlbumList(List<Album> list) {
    albumList = list;
    notifyListeners();
  }

  setCurrentSong(Song song) {
    currentSong = song;
    // 往播放列表插入，如果列表里没有，则置顶，有则忽略
    bool hasSameSong = playList.where((element) => element.name == song.name).isNotEmpty;
    if (!hasSameSong) {
      playList.insert(0, song);
    }
    Prefs.setCurrentSong(song);
    Prefs.setPlayList(playList);
    notifyListeners();
  }

  setPlayList(List<Song> list) {
    Set<String> seenNames = Set<String>();

    List<Song> uniqueList = list.where((song) {
      if (!seenNames.contains(song.name)) {
        seenNames.add(song.name);
        return true;
      }
      return false;
    }).toList();
    // 去重
    playList = uniqueList;
    Prefs.setPlayList(list);
    notifyListeners();
  }

  setPlaying(bool playing) {
    isPlaying = playing;
  }

  setSongState(SongState state) {
    songState = state;
    notifyListeners();
  }

  setPlayMode(PlayMode mode) {
    playMode = mode;
    notifyListeners();
  }
}