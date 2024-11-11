
import 'package:lizhi_music_flutter/model/Album.dart';
import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class MusicSourceUtils {
  MusicSourceUtils._();
  
  
  static List<Song> songs = [];
  static List<Album> albums = [];
  
  static init() async {
    await MusicSourceUtils.getAlbums();
    await MusicSourceUtils.getSongs();
  }
  
  static Future<List<Album>> getAlbums() async {
    if (MusicSourceUtils.albums.isNotEmpty) {
      return MusicSourceUtils.albums;
    }
    final String response = await rootBundle.loadString('assets/json/album.json');
    List<dynamic> list = jsonDecode(response);
    List<Album> albums = list.map((e) => Album.fromJson(e)).toList();
    MusicSourceUtils.albums = albums;
    return albums;
  }
  
  static Future<List<Song>> getSongs() async {
    if (MusicSourceUtils.songs.isNotEmpty) {
      return MusicSourceUtils.songs;
    }
    final String response = await rootBundle.loadString('assets/json/list.json');
    List<dynamic> list = jsonDecode(response);
    List<Song> songs = list.map((e) => Song.fromJson(e)).toList();
    MusicSourceUtils.songs = songs;
    return songs;
  }

  static List<Song> getSongsByAlbum(String albumName) {
    List<Song> songs = [];
    for (var song in MusicSourceUtils.songs) {
      if (song.album == albumName) {
        songs.add(song);
      }
    }
    return songs;
  }
}

