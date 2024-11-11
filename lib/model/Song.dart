class Song {
  final String name;
  final String artist;
  final String album;
  final String cover;
  final String songUrl;

  Song({
    required this.name,
    required this.artist,
    required this.album,
    required this.cover,
    required this.songUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      name: json['name'],
      artist: json['artist'],
      album: json['album'],
      cover: json['cover'],
      songUrl: json['songUrl'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'artist': artist,
      'album': album,
      'cover': cover,
      'songUrl': songUrl,
    };
  }
}