class Album {
  final String name;
  final String cover;

  Album({
    required this.name,
    required this.cover,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      cover: json['cover'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'cover': cover,
    };
  }
}