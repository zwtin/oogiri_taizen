import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/sign_up/sign_up_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class SignUpView extends HookWidget {
  const SignUpView(this.parameter);

  final SignUpViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(signUpViewModelProvider(parameter));
    final emailTextController = useTextEditingController();

    return ProviderListener(
      onChange: (BuildContext context, AlertViewModel alertViewModel) {
        SweetAlert.show(
          context,
          title: alertViewModel.alertEntity.title,
          subtitle: alertViewModel.alertEntity.subtitle,
          showCancelButton: alertViewModel.alertEntity.showCancelButton,
          onPress: alertViewModel.alertEntity.onPress,
          style: alertViewModel.alertEntity.style,
        );
      },
      provider: alertViewModelProvider(parameter.screenId),
      child: ProviderListener(
        onChange:
            (BuildContext context, NavigatorViewModel navigatorViewModel) {
          if (navigatorViewModel.nextWidget != null) {
            Navigator.of(context, rootNavigator: navigatorViewModel.fullScreen)
                .push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  return navigatorViewModel.nextWidget;
                },
                fullscreenDialog: navigatorViewModel.fullScreen,
              ),
            );
          } else if (navigatorViewModel.toRoot) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).pop();
          }
        },
        provider: navigatorViewModelProvider(parameter.screenId),
        child: LoadingOverlay(
          isLoading: viewModel.isLoading,
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
                child: Container(
                  color: Colors.white24,
                  height: 1,
                ),
                preferredSize: const Size.fromHeight(1),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  color: const Color(0xFFFFCC00),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 32,
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
                      SizedBox(
                        width: 300,
                        height: 44,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: TextField(
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
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Email,
                          text: 'Send Email To Confirm',
                          mini: false,
                          onPressed: () {
                            context
                                .read(signUpViewModelProvider(parameter))
                                .sendLoginEmail(
                                  email: emailTextController.text,
                                );
                          },
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            child: const Text(
                              '利用規約',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {},
                          ),
                          const Text(
                            'に同意の上ご登録ください',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                        ],
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
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Google,
                          mini: false,
                          onPressed: () {
                            context
                                .read(signUpViewModelProvider(parameter))
                                .loginWithGoogle();
                          },
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.AppleDark,
                          mini: false,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Twitter,
                          mini: false,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Facebook,
                          mini: false,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
