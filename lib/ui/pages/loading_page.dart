import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/view_model/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final loginViewModel = LoginViewModel();
    return Scaffold(
      body: FutureBuilder(
        future: loginViewModel.checkToken(context, ref),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                const FaIcon(
                  FontAwesomeIcons.instagram,
                  size: 50,
                ),
                // LinearProgressIndicator(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text('FROM'), Text('META')],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
