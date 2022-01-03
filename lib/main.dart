import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/create_project.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/food_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/home_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/init_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/loading_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/message_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/nav_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/project_page.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/see_profile.dart';
import 'package:flutter_instgram_clone_graphql/ui/pages/subscription_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'common/graphql_config.dart';
import 'ui/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  runApp(const ProviderScope(
      child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final client = ref.watch(gqlClientProvider);
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        initialRoute: '/loading',
        routes: {
          '/loading': (_) => const LoadingPage(),
          '/login': (_) => LoginPage(),
          '/nav-page': (_) => const NavPage(),
          '/init': (_) => const InitPage(),
          '/see-profile': (_) => const SeeProfile(),
          '/message': (_) => const MessagePage(),
          '/sub-page': (_) => SubscriptionPage(),
          '/home': (_) => const HomePage(),
        },
      ),
    );
  }
}
