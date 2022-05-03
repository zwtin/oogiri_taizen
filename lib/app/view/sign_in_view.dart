import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view_model/sign_in_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class SignInView extends HookWidget {
  final _key = UniqueKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('SignInView = $_key');

    final viewModel = useProvider(signInViewModelProvider(_key));
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();

    emailTextController.addListener(
      () {
        viewModel.email = emailTextController.text;
      },
    );

    passwordTextController.addListener(
      () {
        viewModel.password = passwordTextController.text;
      },
    );

    emailTextController.text = viewModel.email;
    passwordTextController.text = viewModel.password;

    return RouterWidget(
      key: _key,
      child: LoadingOverlay(
        isLoading: viewModel.isConnecting,
        color: Colors.grey,
        child: Scaffold(
          // ナビゲーションバー
          appBar: AppBar(
            title: const Text(
              'ログイン',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFFCC00),
            elevation: 0, // 影をなくす
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.white24,
                height: 1,
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                color: const Color(0xFFFFCC00),
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          ' ー メールアドレスでログイン ー ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailTextController,
                            decoration: InputDecoration(
                              //Focusしていないとき
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              //Focusしているとき
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'メールアドレス',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordTextController,
                            obscureText: true,
                            decoration: InputDecoration(
                              //Focusしていないとき
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              //Focusしているとき
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'パスワード',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: SignInButton(
                          Buttons.Email,
                          mini: false,
                          onPressed: () {
                            context
                                .read(signInViewModelProvider(_key))
                                .loginWithEmailAndPassword();
                          },
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          const Text(
                            'パスワードを忘れた方は',
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              'こちら',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          ' ー SNSアカウントでログイン ー ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: SignInButton(
                          Buttons.Google,
                          mini: false,
                          onPressed: () {
                            context
                                .read(signInViewModelProvider(_key))
                                .loginWithGoogle();
                          },
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: SignInButton(
                          Buttons.AppleDark,
                          mini: false,
                          onPressed: () {
                            context
                                .read(signInViewModelProvider(_key))
                                .loginWithApple();
                          },
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      //   child: SignInButton(
                      //     Buttons.Twitter,
                      //     mini: false,
                      //     onPressed: () {},
                      //   ),
                      // ),
                      // Container(
                      //   height: 16,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      //   child: SignInButton(
                      //     Buttons.Facebook,
                      //     mini: false,
                      //     onPressed: () {},
                      //   ),
                      // ),
                      // Container(
                      //   height: 16,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
