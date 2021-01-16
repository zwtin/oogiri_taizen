import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/oogiri-taizen-dev.appspot.com/o/images%2Fusers%2Fzwtin.jpg?alt=media&token=e1349bbc-b26f-4933-bcb7-9c930ecb817d',
            ),
            heroAttributes: PhotoViewHeroAttributes(tag: 'imageHero'),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
