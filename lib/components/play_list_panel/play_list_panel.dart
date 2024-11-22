import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/components/bar_music_loading/bar_music_loading.dart';
import 'package:lizhi_music_flutter/model/Song.dart';
import 'package:lizhi_music_flutter/provider/global_provider.dart';
import 'package:lizhi_music_flutter/utils/my_icons.dart';
import 'package:lizhi_music_flutter/utils/song_player.dart';
import 'package:lizhi_music_flutter/utils/user_toast.dart';
import 'package:provider/provider.dart';

class PlayListPanel extends StatefulWidget {
  const PlayListPanel({Key? key}) : super(key: key);

  @override
  State<PlayListPanel> createState() {
    return _PlayListPanel();
  }
}

class _PlayListPanel extends State<PlayListPanel> {
  
  Widget _buildHeader() {
    GlobalProvider globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("当前播放", style: TextStyle(color: Colors.grey[500], fontSize: 14),),
            Text("${globalProvider.currentSong?.name ?? '-'}", style: const TextStyle(color: Color(0xff778ec0), fontSize: 15))
          ],
        ),
        Expanded(child: Container(),),
        if (globalProvider.playMode == PlayMode.order)
          GestureDetector(
            child: Icon(MyIcons.shunxubofang, size: 18,),
            onTap: () {
              globalProvider.setPlayMode(PlayMode.random);
              List<Song> list = [...globalProvider.playList];
              list.shuffle();
              globalProvider.setPlayList(list);
              UserToast.showToast("切换随机播放");
            },
          ),
        if (globalProvider.playMode == PlayMode.random)
          GestureDetector(
            child: Icon(MyIcons.suijibofang, size: 18,),
            onTap: () {
              globalProvider.setPlayMode(PlayMode.order);
              UserToast.showToast("切换顺序播放");
            },
          ),
        const SizedBox(width: 10.0,),
        GestureDetector(
          onTap: () {
            
          },
          child: Icon(MyIcons.lajitong),
        ),
      ],
    );
  }

  Widget _buildList() {
    GlobalProvider globalProvider = Provider.of<GlobalProvider>(context);
    if (globalProvider.playList.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_reaction_rounded, size: 50, color: Colors.grey,),
              SizedBox(height: 20,),
              Text("播放列表为空")
            ],
          ),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: ListView.builder(itemBuilder: (context, index) {
        return _buildListItem(globalProvider.playList[index]);
      }, itemCount: globalProvider.playList.length, padding: EdgeInsets.zero,),
    );
  }

  Widget _buildListItem(Song item) {
    GlobalProvider globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    bool isCurrent = globalProvider.currentSong?.name == item.name;
    return GestureDetector(
      onTap: () {
        SongPlayer.play(item.songUrl);
        globalProvider.setCurrentSong(item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent ? Colors.grey[100] : null,
          borderRadius: BorderRadius.circular(3)
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            if (isCurrent)
              ...[
                const SizedBox(width: 10,),
                const BarMusicLoading(height: 20,),
                const SizedBox(width: 10,),
              ],
            Text("${item.name}", style: TextStyle(fontSize: 16),)
          ]
        )
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.maxFinite,
      height: 360,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildList()
        ],
      ),
    );
  }
}