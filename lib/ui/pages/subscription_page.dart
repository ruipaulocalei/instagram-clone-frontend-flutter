import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SubscriptionPage extends StatelessWidget {

  final subscriptionDocument = gql(
    r'''
    subscription  readySocket  {
      readySocket
    }
  ''',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Subscription(
              options: SubscriptionOptions(
                document: subscriptionDocument
              ),
              builder: (result) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // return Text(result.data!['readySocket'].toString());
                // ResultAccumulator is a provided helper widget for collating subscription results.
                // careful though! It is stateful and will discard your results if the state is disposed
                return ResultAccumulator.appendUniqueEntries(
                  latest: result.data,
                  builder: (context, {results}) =>
                      Text(result.data!['readySocket'].toString(), style: const TextStyle(
                        fontSize: 28
                      ),),
                );
              }
          ),
        ),
      ),
    );
  }
}
