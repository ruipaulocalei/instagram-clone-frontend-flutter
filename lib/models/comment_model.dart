class CommentModel {
  final String id;
  final String payload;
  final bool isMine;

  CommentModel({required this.id, required this.payload, required this.isMine});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(id: json['id'], payload: json['payload'],
        isMine: json['isMine']);
  }
}