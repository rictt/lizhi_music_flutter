import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/components/album_item/album_item.dart';
import 'package:lizhi_music_flutter/components/music_bar_scaffold/music_bar_scaffold.dart';
import 'package:lizhi_music_flutter/model/Album.dart';
import 'package:lizhi_music_flutter/utils/utils.dart';

class Home extends StatefulWidget {
  const Home({ super.key });
  @override
  State<Home> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  List<Album> albums = [];

  @override
  void initState() {
    super.initState();
    albums = MusicSourceUtils.albums;
  }
  
  @override
  Widget build(BuildContext context) {
    return MusicBarScaffold(
      appBarTitle: "Hi, Lizhi",
      child: Column(
        children: [
          _buildAlbumList(),
        ],
      )
    );
  }
  
  Widget _buildAlbumList() {
    return Container(
      height: 320,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("最近", style: TextStyle(fontSize: 18.0, color: Colors.black87, letterSpacing: 0.5),),
              Text("全部", style: TextStyle(fontSize: 15.0, color: Color(0xff4f6a96)))
            ],
          ),
          const SizedBox(height: 8.0,),
          Expanded(
            child: ListView.separated(itemBuilder: (context, index) {
              return _buildAlbumItem(albums[index]);
            }, itemCount: albums.length, scrollDirection: Axis.horizontal, separatorBuilder: (context, index) {
              return const SizedBox(width: 10.0,);
            })
          ),
          // Divider(color: Colors.grey[300], thickness: 0.4,),
        ],
      )
    );
  }

  Widget _buildAlbumItem(Album album) {
    return AlbumItem(album: album);
  }
}
