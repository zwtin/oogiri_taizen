import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailView extends HookWidget {
  const ImageDetailView({this.imageUrl, this.imageTag});

  final String imageUrl;
  final String imageTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(
              imageUrl,
            ),
            heroAttributes: PhotoViewHeroAttributes(
              tag: imageTag,
            ),
            minScale: PhotoViewComputedScale.contained,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
