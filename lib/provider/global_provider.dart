import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/model/Album.dart';
import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:lizhi_music_flutter/utils/event.dart';
import 'package:lizhi_music_flutter/utils/utils.dart';

enum SongState {
  buffering,

  playing,

  paused,

  stopped,
}

class GlobalProvider with ChangeNotifier {
  // 正在播放的歌曲、播放状态、播放时长、歌单列表
  List<Album> albumList = MusicSourceUtils.albums;
  Song? currentSong;
  List<Song> playList = [];
  bool isPlaying = false;
  // PlayerState state = PlayerState.stopped;
  SongState songState = SongState.stopped;

  GlobalProvider() {
    eventBus.on<SongPlayingStateChange>().listen((event) {
      setSongState(event.state);
    });
  }
  
  setAlbumList(List<Album> list) {
    albumList = list;
    notifyListeners();
  }

  setCurrentSong(Song song) {
    currentSong = song;
    notifyListeners();
  }

  setPlayList(List<Song> list) {
    playList = list;
    notifyListeners();
  }

  setPlaying(bool playing) {
    isPlaying = playing;
  }

  setSongState(SongState state) {
    songState = state;
    notifyListeners();
  }
}