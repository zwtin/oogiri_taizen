import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/view_model/sign_up_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class SignUpView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('SignUpView = $_key');
    final viewModel = useProvider(signUpViewModelProvider(_key));
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
              '新規登録',
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
                      Row(
                        children: [
                          const Spacer(
                            flex: 1,
                          ),
                          Checkbox(
                            value: viewModel.isAgreeWithTerms,
                            onChanged: (isAgree) {
                              context
                                  .read(signUpViewModelProvider(_key))
                                  .changeAgreeState(
                                    isAgree: isAgree,
                                  );
                            },
                          ),
                          InkWell(
                            onTap: () async {
                              await context
                                  .read(signUpViewModelProvider(_key))
                                  .transitionToTermsOfService();
                            },
                            child: const Text(
                              '利用規約',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Text(
                            ' に同意します',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                      Container(
                        height: 16,
                      ),
                      const Center(
                        child: Text(
                          ' ー メールアドレスで新規登録 ー ',
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
                          text: 'Send Email To Confirm',
                          mini: false,
                          onPressed: () {
                            context
                                .read(signUpViewModelProvider(_key))
                                .createWithEmailAndPassword();
                          },
                        ),
                      ),
                      Container(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          ' ー SNSアカウントで新規登録 ー ',
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
                          onPressed: () {},
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
                          onPressed: () {},
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
