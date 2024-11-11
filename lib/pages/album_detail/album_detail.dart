
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/components/album_item/album_item.dart';
import 'package:lizhi_music_flutter/components/music_bar_scaffold/music_bar_scaffold.dart';
import 'package:lizhi_music_flutter/model/Album.dart';
import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:lizhi_music_flutter/provider/global_provider.dart';
import 'package:lizhi_music_flutter/utils/song_player.dart';
import 'package:lizhi_music_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

List<LinearGradient> generateLinearGradients(int count) {
  final List<LinearGradient> gradients = [];
  const List<Color> colors = [
    Color(0xff94377f),
    Color(0xff792383),
    Color(0xffd32f2f),
    Color(0xffe53935),
    Color(0xffef5350),
    Color(0xfff44336),
    Color(0xffe91e63),
    Color(0xffec407a),
    Color(0xffe81e50),
    Color(0xff9c27b0),
    Color(0xffab47bc),
    Color(0xff7e57c2),
    Color(0xff5c6bc0),
    Color(0xff3f51b5),
    Color(0xff5677fc),
    Color(0xffFF5733), // 橙红色
    Color(0xff33FF57), // 草绿色
    Color(0xff3357FF), // 蓝色
    Color(0xffFF33A1), // 粉红色
    Color(0xff33FFF7), // 青色
    Color(0xffFF3333), // 红色
    Color(0xff33FF33), // 绿色
    Color(0xff3333FF), // 深蓝色
    Color(0xffFF33FF), // 紫色
    Color(0xff33FFCC), // 浅绿色
    Color(0xffFF3399), // 玫瑰红
    Color(0xff33FFFF), // 天蓝色
    Color(0xffFF3366), // 桃红色
    Color(0xff33FF99), // 薄荷绿
    Color(0xffFF33CC), // 紫罗兰
  ];

  Color getRandomColor(Random random) {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0, // 不透明度
    );
  }
  Random random = Random();

  for (int i = 0; i < count; i++) {
    // final startColor = colors[i % colors.length];
    // final endColor = colors[(i + 1) % colors.length];
    final startColor = getRandomColor(random);
    final endColor = getRandomColor(random);
    gradients.add(
      LinearGradient(
        colors: [startColor, endColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  return gradients;
}

List<LinearGradient> lgList = generateLinearGradients(20);

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({
    Key? key
  }) : super(key: key);
  
  @override
  State<AlbumDetail> createState() {
    return _AlbumDetail();
  }
}

class _AlbumDetail extends State<AlbumDetail> {
  Album? album;
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        album = args["album"];
        if (album != null) {
          songs = MusicSourceUtils.getSongsByAlbum(album!.name);
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (album == null) {
      return Container();
    }
    return MusicBarScaffold(
      showBackIcon: true,
      appBarTitle: album!.name,
      child: Column(
        children: [
          _buildHeader(),
          _buildList(),
        ],
      )
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 30.0,),
        Center(
          child: AlbumItem(album: album!, coverWidth: 210, coverHeight: 210, textAlign: TextAlign.center,)
        ),
        const Text("李志"),
        const SizedBox(height: 14.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: _buildButton("播放", Icons.play_arrow_rounded)),
              const SizedBox(width: 10.0,),
              Expanded(flex: 1, child: _buildButton("随机播放", Icons.music_note)),
            ],
          ),
        )
        
      ],
    );
  }

  Widget _buildButton(String text, IconData icon) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 20,),
            const SizedBox(width: 4.0,),
            Text(text, style: const TextStyle(fontSize: 14, color: Colors.black),)
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${songs.length}首音乐", style: TextStyle(fontSize: 15, letterSpacing: 0.5, color: Colors.grey[500]),),
          const SizedBox(height: 6.0,),
          const Divider(),
          ...songs.asMap().entries.map((entry) {
            return _buildListItem(entry.value, entry.key);
          }),
        ],
      ),
    );
  }

  Widget _buildListItem(Song song, int index) {
    GlobalProvider globalProvider = Provider.of<GlobalProvider>(context);
    SongState state = globalProvider.songState;
    bool isBuffering = state == SongState.buffering;
    bool isPlaying = state == SongState.playing;
    bool isPaused = state == SongState.paused;
    return GestureDetector(
      onTap: () {
        SongPlayer.play(song.songUrl);
        globalProvider.setCurrentSong(song);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(child: Text("${index + 1}", style: const TextStyle(fontSize: 16,),)),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: Container(
                height: 75,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 0.5))
                ),
                child: Row(children: [Text(song.name)]),
              )
            )
          ],
        )
      )
    );
  }
}