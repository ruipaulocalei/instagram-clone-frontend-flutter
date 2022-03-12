import 'package:flutter/cupertino.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// final StateProvider<String> authTokenProvider =
//     StateProvider<String>((_) => '', name: 'tokenP');

final gqlClientProvider = Provider<ValueNotifier<GraphQLClient>>((ref) {
  final String token = ref.watch(bearerToken.state).state;

  final HttpLink _httpLink = HttpLink('http://10.0.2.2:4200/graphql',
      defaultHeaders: {if (token.isNotEmpty) 'jwt-token': token});
  final _webSocketLink = WebSocketLink('ws://10.0.2.2:4200/graphql');
  var _link = Link.split(
      (request) => request.isSubscription, _webSocketLink, _httpLink);

  return ValueNotifier(
    GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
});
