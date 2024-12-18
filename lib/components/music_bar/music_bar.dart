import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/components/music_popup_route/music_popup_route.dart';
import 'package:lizhi_music_flutter/components/play_list_panel/play_list_panel.dart';
import 'package:lizhi_music_flutter/constants/constants.dart';
import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:lizhi_music_flutter/provider/global_provider.dart';
import 'package:lizhi_music_flutter/utils/prefs.dart';
import 'package:lizhi_music_flutter/utils/song_player.dart';
import 'package:provider/provider.dart';

class MusicBar extends StatefulWidget {
  @override
  State<MusicBar> createState() {
    return _MusicBar();
  }
}

class _MusicBar extends State<MusicBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void showPlayList() {
    Navigator.of(context).push(
      MusicPopupRoute(
        slideTransitionFrom: SlideTransitionFrom.bottom,
        builder: (context) {
          return PlayListPanel();
        }
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    BorderSide borderSide = BorderSide(color: theme.splashColor, width: 0.5);
    GlobalProvider globalProvider = Provider.of<GlobalProvider>(context, listen: true);
    SongState state = globalProvider.songState;
    bool isBuffering = state == SongState.buffering;
    bool isPlaying = state == SongState.playing;
    Song? currentSong = globalProvider.currentSong;

    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(top: borderSide, bottom: borderSide)
      ),
      height: LayoutConstants.bottomMusicBarHeight,
      child: Row(
        children: [
          _buildRotationImage(isPlaying),
          const SizedBox(width: 10.0,),
          Text(globalProvider.currentSong?.name ?? "未播放歌曲"),
          Expanded(flex: 1, child: Container()),
          if (isBuffering)
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: CircularProgressIndicator(color: Colors.grey[500],),
              ),
            ),
            const SizedBox(width: 20.0,),
          if (isPlaying) 
            GestureDetector(
              onTap: () => pausePlay(currentSong),
              child: const Icon(Icons.pause, size: 40, color: Colors.black87,),
            ),
          if (!isPlaying)
            GestureDetector(
              onTap: () => resumePlay(currentSong),
              child: const Icon(Icons.play_arrow_rounded, size: 38, color: Colors.black87,),
            ),
          const SizedBox(width: 10,),
          const Icon(Icons.skip_next_rounded, size: 40, color: Colors.black87,),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: () => showPlayList(),
            child: const Icon(Icons.menu_rounded, size: 28, color: Colors.black87,),
          )
        ],
      )
    );
  }

  void resumePlay(Song? currentSong) {
    if (currentSong == null) {
      return;
    }
    _controller.forward();
    SongPlayer.play(currentSong.songUrl);
  }

  void pausePlay(Song? currentSong) {
    if (currentSong == null) {
      return;
    }
    _controller.stop();
    SongPlayer.paused();
    GlobalProvider globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    globalProvider.setSongState(SongState.paused);
  }

  Widget _buildRotationImage(bool isPlay) {
    if (isPlay && _controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.asset("assets/images/lizhi.png", width: 60, height: 90, fit: BoxFit.cover,),
    );
    return RotationTransition(turns: _controller, child: child,);
  }
}