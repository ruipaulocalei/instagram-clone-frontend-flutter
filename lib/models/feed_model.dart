import 'package:flutter_instgram_clone_graphql/models/comment_model.dart';
import 'package:flutter_instgram_clone_graphql/models/user_model.dart';

class FeedModel {
  String id = '';
  String caption = '';
  int numberLikes = 0;
  bool isLiked = false;
  String file = '';
  UserModel user = UserModel(id: '', username: '', name: '');
  List<CommentModel> comments = List<CommentModel>.empty(growable: true);

  FeedModel({
    required this.id,
    required this.caption,
    required this.numberLikes,
    required this.isLiked,
    required this.file,
    required this.user,
    required this.comments
  });

  FeedModel.fromJson(Map<String, dynamic> json) {
    id= json['id'];
    caption= json['caption'];
    numberLikes= json['numberLikes'];
    isLiked= json['isLiked'];
    file= json['file'];
    user= UserModel.fromJson(json['user']);
    if(json['comments'] != null) {
      json['comments'].forEach((v) {
        comments.add(CommentModel.fromJson(v));
      });
    }
  }
}
