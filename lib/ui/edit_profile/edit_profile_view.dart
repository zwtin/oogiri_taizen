import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/edit_profile/edit_profile_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class EditProfileView extends HookWidget {
  final id = StringExtension.randomString(8);

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(editProfileViewModelProvider(id));
    final nameTextController = useTextEditingController();
    final introductionTextController = useTextEditingController();

    nameTextController.addListener(
      () {
        viewModel.editedUser.name = nameTextController.text;
      },
    );

    introductionTextController.addListener(
      () {
        viewModel.editedUser.introduction = introductionTextController.text;
      },
    );

    nameTextController.text = viewModel.editedUser.name;
    introductionTextController.text = viewModel.editedUser.introduction;

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
      provider: alertViewModelProvider(id),
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
        provider: navigatorViewModelProvider(id),
        child: LoadingOverlay(
          isLoading: viewModel.isConnecting,
          color: Colors.grey,
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                'プロフィール編集',
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
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    context.read(editProfileViewModelProvider(id)).postUser();
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                Container(
                  color: const Color(0xFFFFCC00),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    imageUrl: viewModel.editedUser.imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget:
                                        (context, url, dynamic error) =>
                                            Image.asset(
                                      'assets/icon/no_user.jpg',
                                    ),
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: viewModel.imageFile != null
                                      ? Image.file(
                                          viewModel.imageFile,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read(editProfileViewModelProvider(id))
                                      .getImage();
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 16,
                        ),
                        Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '名前　　',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                width: 16,
                              ),
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  child: TextField(
                                    controller: nameTextController,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    decoration: const InputDecoration.collapsed(
                                      border: InputBorder.none,
                                      hintText: null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '自己紹介',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                width: 16,
                              ),
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  child: TextField(
                                    controller: introductionTextController,
                                    maxLines: 6,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    decoration: const InputDecoration.collapsed(
                                      border: InputBorder.none,
                                      hintText: null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        Container(
                          height: 16,
                        ),
                      ],
                    ),
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
