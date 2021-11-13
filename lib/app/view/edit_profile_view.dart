import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/view_model/edit_profile_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class EditProfileView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('EditProfileView = $_key');

    final viewModel = useProvider(editProfileViewModelProvider(_key));
    final nameTextController = useTextEditingController();
    final introductionTextController = useTextEditingController();

    nameTextController.addListener(
      () {
        viewModel.editedName = nameTextController.text;
      },
    );

    introductionTextController.addListener(
      () {
        viewModel.editedIntroduction = introductionTextController.text;
      },
    );

    nameTextController.text = viewModel.editedName;
    introductionTextController.text = viewModel.editedIntroduction;

    return RouterWidget(
      key: _key,
      child: LoadingOverlay(
        isLoading: viewModel.isConnecting,
        color: Colors.grey,
        child: Scaffold(
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
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.white24,
                height: 1,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                ),
                onPressed: () async {
                  final viewModel =
                      context.read(editProfileViewModelProvider(_key));
                  await viewModel.updateProfile();
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      if ((viewModel.loginUserImageUrl ?? '')
                                          .isEmpty) {
                                        return Image.asset(
                                          'assets/images/no_user.jpg',
                                        );
                                      }
                                      return CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl:
                                            viewModel.loginUserImageUrl ?? '',
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                      );
                                    },
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: viewModel.imageFile == null
                                      ? Container()
                                      : Image.file(
                                          viewModel.imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await context
                                      .read(editProfileViewModelProvider(_key))
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
