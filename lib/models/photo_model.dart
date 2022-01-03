class PhotoModel {
  String id;
  String file;
  String caption;

  PhotoModel({required this.id, required this.file, required this.caption});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(id: json['id'], file: json['file'], caption: json['caption']);
  }
}