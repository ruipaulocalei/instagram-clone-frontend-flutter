class ProfileModel {
  String id = '';
  String name = '';
  String username = '';
  String? bio;
  bool isMe = false;
  bool isFollowing = false;
  int totalPublish = 0;
  int totalFollowing = 0;
  int totalFollowers = 0;

  ProfileModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.bio,
      required this.isMe,
      required this.isFollowing,
      required this.totalPublish,
      required this.totalFollowing,
      required this.totalFollowers});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      isMe: json['isMe'],
      isFollowing: json['isFollowing'],
      totalFollowers: json['totalFollowers'],
      totalPublish: json['totalPublish'],
      totalFollowing: json['totalFollowing'],
    );
  }
}
