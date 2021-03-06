import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/models/feed_model.dart';
import 'package:flutter_instgram_clone_graphql/models/user_model.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/profile/circle_avatar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InitPage extends ConsumerWidget {
  const InitPage(this.repository, {Key? key}) : super(key: key);

  final Map<String, Object> repository;

  /// Extract the repository data for updating the fragment
  Map<String, Object>? extractRepositoryData(Map<String, Object?> data) {
    final action = data['feed'] as Map<String, Object>?;
    if (action == null) {
      return null;
    }
    return action;
  }

  /// Get whether the repository is currently starred, according to the current Query
  bool? get liked => repository['isLiked'] as bool?;

  /// Build an optimisticResult based on whether [viewerIsStarrring]
  Map<String, dynamic> expectedResult(bool isLiked) => <String, dynamic>{
        'feed': {
          '__typename': 'PhotoModel',
          'id': repository['id'],
          'isLiked': isLiked,
        }
      };

  OnMutationUpdate get update => (cache, result) {
        if (result!.hasException) {
          print(result.exception);
        } else {
          final updated = {
            ...repository,
            ...extractRepositoryData(result.data!)!,
          };
          cache.writeFragment(
            Fragment(
              document: gql(
                '''
                  fragment fields on PhotoModel {
                    isLiked
                  }
                  ''',
              ),
            ).asRequest(idFields: {
              '__typename': updated['__typename'],
              'id': updated['id'],
            }),
            data: updated,
          );
        }
      };

  @override
  Widget build(BuildContext context, ref) {
    // const meQuery = """
    // query {
    //   me {
    //     id
    //     username
    //     name
    //     }
    //   }
    // """;

    const feedQuery = """
      query {
        feed {
          id
          caption
          numberLikes
          isLiked
          file
          user {
            id
            username
            name
          }
          comments {
            id
            payload
            isMine
          }
          commentNumber
        }
      }
    """;

    const likePhoto = """
     mutation likePhoto(\$input: LikePhotoInput!) {
        likePhoto(input: \$input) {
          ok
          error
        }
     }
    """;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InstaClone',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        actions: const [
           FaIcon(FontAwesomeIcons.user),
        ],
      ),
      body: Center(
        child: Query(
            options: QueryOptions(document: gql(feedQuery)),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              } else if (result.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // final me = result.data!['me'];
              // final userData = UserModel.fromJson(me);
              final feedData = result.data!['feed'] as List<dynamic>;
              // extractRepositoryData(result.data!['feed']);
              final feeds = feedData.map((f) => FeedModel.fromJson(f)).toList();
              feedData.map((e) {
                if (e != null) {
                  return extractRepositoryData(e);
                }
              });
              return feeds.isNotEmpty
                  ? ListView.builder(
                      itemCount: feeds.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, i) {
                        final size = MediaQuery.of(context).size;
                        final feed = feeds[i];
                        final numberLike = feed.numberLikes;
                        final isLiked = feed.isLiked;
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Row(
                                  children: [
                                    const CircleAvatarWidget(
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    _goToUserProfile(context, feed.user)
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.3, color: Colors.grey),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: feed.file,
                                  height: size.height * 0.4,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  // progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Mutation(
                                  options: MutationOptions(
                                      document: gql(likePhoto),
                                      // ignore: void_checks
                                      update: (GraphQLDataProxy? cache,
                                          QueryResult? result) {
                                        return cache;
                                      },
                                      onCompleted: (data) {
                                        refetch!();
                                      }),
                                  builder: (runMutation, QueryResult? result) {
                                    return IconButton(
                                        onPressed: () {
                                          runMutation({
                                            "input": {
                                              "id": feed.id,
                                            }
                                          });
                                        },
                                        icon: isLiked
                                            ? const Icon(Icons.favorite,
                                                color: Colors.red)
                                            : const Icon(
                                                Icons.favorite_border));
                                  }),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, bottom: 8),
                                child: Text(
                                  numberLike > 1
                                      ? '$numberLike Likes'
                                      : '$numberLike Like',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 14,
                                ),
                                child: Row(
                                  children: [
                                    _goToUserProfile(context, feed.user),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Expanded(
                                      child: Text(
                                        feed.caption,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              feed.comments.isNotEmpty
                                  ? ExpansionTile(
                                      title: const Text(
                                        'Comments',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      children: _buildList(feed),
                                    )
                                  : const Text('')
                            ],
                          ),
                        );
                      })
                  : const Center(
                      child: Text('Follow users to see feeds'),
                    );
            }),
      ),
    );
  }

  _buildList(FeedModel feed) {
    var l = List<Widget>.empty(growable: true);
    feed.comments.forEach((element) {
      l.add(Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              feed.user.username,
              maxLines: 1000,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(element.payload)
          ],
        ),
      ));
    });
    return l;
  }

  Widget _goToUserProfile(BuildContext context, UserModel user) {
    return Consumer(
      builder: (_, ref, __) {
        return InkWell(
          child: Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // debugPrint(feed.user.username);
            ref.read(selectedUser.state).state = user;
            Navigator.of(context).pushNamed('/see-profile');
          },
        );
      },
    );
  }
}
