import 'dart:convert';

import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _instance;

class Keys {
  static const String currentSong = "currentSong";
  static const String playList = "playList";
}


class Prefs {
  Prefs._();
  static bool load = false;

  static init() async {
    _instance = await SharedPreferences.getInstance();
    load = true;
  }
  static getInstance() {
    return _instance;
  }

  static Song? getCurrentSong() {
    final data = _instance.getString(Keys.currentSong);
    if (data != null) {
      Song song = Song.fromJson(json.decode(data));
      return song;
    }
    return null;
  }

  static setCurrentSong(Song song) async {
    await _instance.setString(Keys.currentSong, json.encode(song.toJSON()));
  }

  static setPlayList(List<Song> list) async {
    await _instance.setStringList(Keys.playList, list.map((e) => json.encode(e.toJSON())).toList());
  }

  static List<Song> getPlayList() {
    final data = _instance.getStringList(Keys.playList);
    if (data != null) {
      return data.map((e) => Song.fromJson(json.decode(e))).toList();
    }
    return [];
  }
}