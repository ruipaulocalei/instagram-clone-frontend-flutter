import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/models/user_model.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Search extends SearchDelegate {

  String searchUser = """
    query searchUser(\$input: SearchUserInput!) {
      searchUser(input: \$input) {
        error
        ok
        users {
          id
          username
          name
        }
      }
    }
  """;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = '';
      }, icon: const Icon(Icons.clear),)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(onPressed: () {
      close(context, null);
    }, icon: AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation,
    ),);
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if(query.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Query(
      options: QueryOptions(
        document: gql(searchUser),
        variables: {
          "input": {
            "query": query
          }
        },
        pollInterval: const Duration(seconds: 10),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Center(child: Text(result.exception.toString()));
        }

        if (result.isLoading) {
          return const Center(child: Text('Loading'));
        }

        List users = result.data!['searchUser']['users'] as List<dynamic>;
        final usersData = users.map((e) => UserModel.fromJson(e)).toList();

        return users.isNotEmpty ? ListView.builder(
            itemCount: usersData.length,
            itemBuilder: (context, index) {
              final user = usersData[index];

              return Consumer(builder: (_, ref, __) {
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.username),
                  onTap: () {
                    ref.read(selectedUser.state).state = user;
                    Navigator.of(context)
                        .pushNamed('/see-profile');
                  },
                );
              });
            }) : Center(child: Text('No user $query found'));
      },
    );
  }
}