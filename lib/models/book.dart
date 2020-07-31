class BookModel {
  final String id;
  final String name;
  final String img;
  final int type;
  final String intro;
  final int status;
  double progress;

  BookModel({
    this.id,
    this.name,
    this.img,
    this.type,
    this.intro,
    this.status,
    this.progress,
  });

  BookModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        img = json['img'],
        type = json['type'],
        intro = json['intro'],
        status = json['status'],
        progress = json['progress'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'img': img,
        'type': type,
        'intro': intro,
        'status': status,
        'progress': progress,
      };
}
