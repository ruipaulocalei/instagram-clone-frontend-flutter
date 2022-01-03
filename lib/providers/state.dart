import 'package:flutter/cupertino.dart';
import 'package:flutter_instgram_clone_graphql/models/feed_model.dart';
import 'package:flutter_instgram_clone_graphql/models/profile_model.dart';
import 'package:flutter_instgram_clone_graphql/models/user_model.dart';
import 'package:flutter_instgram_clone_graphql/ui/queries/profileQuery.dart';
import 'package:flutter_instgram_clone_graphql/view_model/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bearerToken = StateProvider((ref) => '');
final isSaving = StateProvider((ref) => false);
// final seeProfileProvider =
// FutureProvider.family<UserModel, String>((ref, username) => profileQuery(username));
final selectedUser = StateProvider((ref) => UserModel(username: '', id: '', name: ''));
final selectedProfileToSendMessage =
StateProvider((ref) => '');

class ModelId {
  String id;

  ModelId({required this.id});

  factory ModelId.fromJson(Map<String, dynamic> json) {
    return ModelId(id: json['id']);
  }
}