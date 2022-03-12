import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/models/photo_model.dart';
import 'package:flutter_instgram_clone_graphql/models/profile_model.dart';
import 'package:flutter_instgram_clone_graphql/models/user_model.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/button_widget.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/input_widget.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/profile/circle_avatar_widget.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/profile/follow_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SeeProfile extends ConsumerWidget {
  const SeeProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    String seeProfileQuery = """
      query seeProfile(\$input: String!) {
        seeProfile(input: \$input) {
          ok
          error
          profile {
            id
            username
            name
            bio
            isMe
            isFollowing
            totalPublish
            totalFollowing
            totalFollowers
            photos {
              id
              file
              caption
            }
          }
        }
      }
    """;
    String unfollowUser = """
      mutation unfollowUser(\$input:FollowUserInput!) {
        unfollowUser(input:\$input) {
          ok
          error
        }
      }
    """;
    String followUser = """
      mutation followUser(\$input:FollowUserInput!) {
        followUser(input:\$input) {
          ok
          error
        }
      }
    """;
    final profileState = ref.watch(selectedUser.state).state.username;
    var isSavingProvider = ref.read(isSaving.state).state;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            profileState,
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
        ),
        body: Query(
          options: QueryOptions(
              document: gql(seeProfileQuery),
              variables: {'input': profileState}),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final profileQuery = result.data!['seeProfile'];
            final profileGraphql = profileQuery['profile'];
            final photos = profileGraphql['photos'] as List<dynamic>;
            final profile = ProfileModel.fromJson(profileQuery['profile']);
            final photosData =
                photos.map((e) => PhotoModel.fromJson(e)).toList();
            // debugPrint(profileGraphql.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatarWidget(
                            height: 90,
                            width: 90,
                          ),
                          const Spacer(),
                          FollowWidget(
                              number: profile.totalPublish, text: 'Publishes'),
                          const SizedBox(width: 16),
                          FollowWidget(
                              number: profile.totalFollowers,
                              text: 'Followers'),
                          const SizedBox(width: 16),
                          FollowWidget(
                              number: profile.totalFollowing,
                              text: 'Following'),
                          const SizedBox(width: 16),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 4),
                        child: Text(
                          profile.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        profile.bio ?? '',
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      !profile.isMe && profile.isFollowing
                          ? Row(
                              children: [
                                Expanded(
                                  child: Mutation(
                                    options: MutationOptions(
                                        document: gql(unfollowUser),
                                        fetchPolicy: FetchPolicy.noCache,
                                        onCompleted: (data) {
                                          // isSavingProvider = true;
                                          refetch!();
                                          isSavingProvider = false;
                                        }),
                                    builder:
                                        (runMutation, QueryResult? result) {
                                      return ButtonWidget(
                                        text: isSavingProvider
                                            ? 'Unfollowing'
                                            : 'Unfollow',
                                        onPressed: isSavingProvider
                                            ? null
                                            : () {
                                                isSavingProvider = true;
                                                runMutation({
                                                  "input": {
                                                    "username": profileState
                                                  }
                                                });
                                              },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: ButtonWidget(
                                    text: 'Message',
                                    onPressed: () {
                                      ref
                                          .read(selectedProfileToSendMessage
                                              .state)
                                          .state = profile.id;
                                      Navigator.of(context)
                                          .pushNamed('/message');
                                      // Navigator.of(context).pushNamed('/sub-page');
                                    },
                                  ),
                                ),
                              ],
                            )
                          : (profile.isMe)
                              ? ButtonWidget(
                                  text: 'Edit Profile',
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (_) {
                                          return Container(
                                            color: const Color(0xff757575),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15))),
                                              child: Form(
                                                child: Column(
                                                  children: [
                                                    TextFormField(),
                                                    // InputWidget(controller: null,
                                                    //   validatorFunction: (String value) {  },
                                                    //   labelText: 'Name',)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  })
                              : Mutation(
                                  options: MutationOptions(
                                      document: gql(followUser),
                                      fetchPolicy: FetchPolicy.noCache,
                                      onCompleted: (data) {
                                        refetch!();
                                        isSavingProvider = false;
                                      }),
                                  builder: (runMutation, QueryResult? result) {
                                    return ButtonWidget(
                                      text: isSavingProvider
                                          ? 'Following'
                                          : 'Follow',
                                      onPressed: isSavingProvider
                                          ? null
                                          : () {
                                              isSavingProvider = true;
                                              runMutation({
                                                "input": {
                                                  "username": profileState
                                                }
                                              });
                                            },
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    crossAxisCount: 2,
                    children: List.generate(photosData.length, (i) {
                      final photo = photosData[i];
                      // return Text(photo['caption']);
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: photo.file,
                            fit: BoxFit.cover,
                            // progressIndicatorBuilder: (context, url, downloadProgress) =>
                            //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ],
                      );
                    }),
                  ),
                )
              ],
            );
          },
        ));
  }
}
