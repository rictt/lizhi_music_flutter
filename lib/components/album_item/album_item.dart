import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lizhi_music_flutter/model/Album.dart';
import 'package:lizhi_music_flutter/pages/album_detail/album_detail.dart';

class AlbumItem extends StatelessWidget {
  final Album album;
  final double coverWidth;
  final double coverHeight;
  final TextAlign textAlign;
  const AlbumItem({
    Key? key,
    required this.album,
    this.coverWidth = 200,
    this.coverHeight = 200,
    this.textAlign = TextAlign.left,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          settings: RouteSettings(arguments: {
            "album": album
          }),
          builder: (context) => const AlbumDetail()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              width: 200,
              height: 200,
              color: Colors.grey,
              child: CachedNetworkImage(
                imageUrl: album.cover,
              ),
            ),
          ),
          
          Container(
            width: coverWidth,
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(album.name, style: const TextStyle(fontSize: 16.0), textAlign: textAlign,),
          )
        ],
      )
    );
  }
}