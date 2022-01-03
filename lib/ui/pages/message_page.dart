import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MessagePage extends ConsumerWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    String sendMessage = """
      mutation sendMessage(\$input: SendMessageInput!) {
        sendMessage(input: \$input) {
          ok
          error
        }
      }
    """;
    final profileState = ref.watch(selectedProfileToSendMessage.state).state;
    var t = '';
    return Scaffold(
        appBar: AppBar(title: Text('Messages')),
        body: Mutation(
          options: MutationOptions(
              document: gql(sendMessage),
              fetchPolicy: FetchPolicy.noCache,
              onCompleted: (data) {}),
          builder: (runMutation, QueryResult? result) {
            return Form(
              // key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int i) {
                        return Text('Message $i');
                      },),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration:
                          InputDecoration(hintText: 'Enter message'),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.send))
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
