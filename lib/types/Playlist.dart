class Poster {
  String id;
  String title;
  String description;
  String thumbnail;
  List<Poster> videos;

  Poster({this.id, this.title, this.description, this.thumbnail});

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }

  Map toJson() => {
        "id": this.id,
        "title": this.title,
        "description": this.description,
        "thumbnail": this.thumbnail
      };
}
