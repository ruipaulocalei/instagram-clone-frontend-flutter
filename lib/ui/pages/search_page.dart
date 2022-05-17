import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/search/search.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchPage extends StatelessWidget {

  // String searchUser = """
  //   query searchUser(\$input: SearchUserInput!) {
  //     searchUser(input: \$input) {
  //       error
  //       ok
  //       users {
  //         id
  //         username
  //       }
  //     }
  //   }
  // """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InstaClone',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black,),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(top:16),
        child: Align(
          alignment: Alignment.topCenter,
            child: Text('Start searching by username', style: TextStyle(fontSize: 20),)),
      ),
      // body: Query(
      //   options: QueryOptions(
      //     document: gql(searchUser),
      //     // this is the query string you just created
      //     variables: {
      //       "input": {
      //         "query": "r"
      //       }
      //     },
      //     pollInterval: Duration(seconds: 10),
      //   ),
      //   // Just like in apollo refetch() could be used to manually trigger a refetch
      //   // while fetchMore() can be used for pagination purpose
      //   builder: (QueryResult result,
      //       {VoidCallback? refetch, FetchMore? fetchMore}) {
      //     if (result.hasException) {
      //       return Text(result.exception.toString());
      //     }
      //
      //     if (result.isLoading) {
      //       return const Center(child: Text('Loading'));
      //     }
      //
      //     // it can be either Map or List
      //     List users = result.data!['searchUser']['users'] as List<dynamic>;
      //
      //     return users.isNotEmpty ? ListView.builder(
      //         itemCount: users.length,
      //         itemBuilder: (context, index) {
      //           final user = users[index];
      //
      //           return Text(user['username']);
      //         }) : const Text('Loading');
      //   },
      // ),
    );
  }
}
