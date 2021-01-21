import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oogiritaizen/data/model/extension/string_extension.dart';
import 'package:photo_view/photo_view.dart';

class ImageEditView extends HookWidget {
  ImageEditView(this.imageFile);

  final File imageFile;
  final id = StringExtension.randomString(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: FileImage(imageFile),
          ),
          _buildTopBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const topBarHeight = 108.0;
    return Container(
      color: Colors.black.withOpacity(0.4),
      height: topBarHeight,
      child: Column(
        children: [
          Container(height: statusBarHeight),
          SizedBox(
            height: topBarHeight - statusBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  width: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
