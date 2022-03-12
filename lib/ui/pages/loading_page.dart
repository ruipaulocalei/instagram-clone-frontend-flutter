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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    FaIcon(FontAwesomeIcons.instagram)
                    // LinearProgressIndicator(),
                    // Text('FROM'),
                    // Text('PALM RISE')
                  ],
                ),
              ),
            );
        },),
    );
  }
}
