import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instgram_clone_graphql/common/show_dialog.dart';
import 'package:flutter_instgram_clone_graphql/models/response_message.dart';
import 'package:flutter_instgram_clone_graphql/providers/state.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/button_widget.dart';
import 'package:flutter_instgram_clone_graphql/ui/widgets/input_widget.dart';
import 'package:flutter_instgram_clone_graphql/view_model/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final loginViewModel = LoginViewModel();
  final String login = """
  mutation login(\$input: LoginInputDto!) {
    login(input: \$input) {
    ok
    error
    token
  }
}
""";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
    var isLoadingWatch = ref.watch(isSaving.state).state;
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Mutation(
                  options: MutationOptions(
                      document: gql(login),
                      fetchPolicy: FetchPolicy.noCache,
                      onCompleted: (data) {
                        final loginData = data['login'];
                        // final dataResp = ResponseMessage.fromJson(loginData);
                        if (loginData['ok']) {
                          loginViewModel.setToken(
                              context, ref, loginData['token']);
                        } else {
                          showDialogWidget(context, 'Wrong Credentials',
                              loginData['error'].toString());
                        }
                      }),
                  builder: (runMutation, QueryResult? result) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'INSTAGRAM',
                                  style: TextStyle(
                                      fontSize: 24,
                                      letterSpacing: 1.4,
                                      fontWeight: FontWeight.w300),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            InputWidget(
                              labelText: 'Username/E-mail',
                              // initialValue: 'rui_oficial',
                              controller: usernameController,
                              // inputFunction: (String value) => value = '',
                              validatorFunction: (String value) => value.isEmpty
                                  ? 'Insert username/e-mail'
                                  : null,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InputWidget(
                              labelText: 'Password',
                              // initialValue: '123456',
                              controller: passwordController,
                              obscureText: true,
                              // inputFunction: (String value) => value = '',
                              validatorFunction: (String value) =>
                                  value.isEmpty ? 'Insert password' : null,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ButtonWidget(
                              text: 'Login',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  runMutation({
                                    "input": {
                                      "username":
                                          usernameController.text.trim(),
                                      "password": passwordController.text.trim()
                                    }
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
        ));
  }
}
