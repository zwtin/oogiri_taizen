import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:oogiri_taizen/extension/date_time_extension.dart';

class TopicCardWidget extends HookWidget {
  const TopicCardWidget({
    this.userImageUrl,
    this.onTapUserImage,
    this.createdTime,
    this.userName,
    this.menuList,
    required this.text,
    this.imageUrl,
    this.imageTag,
    this.onTapImage,
    this.onTap,
  });

  final String? userImageUrl;
  final void Function()? onTapUserImage;
  final DateTime? createdTime;
  final String? userName;
  final List<ListTile>? menuList;
  final String text;
  final String? imageUrl;
  final String? imageTag;
  final void Function()? onTapImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTapUserImage,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: (userImageUrl != null && userImageUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              imageUrl: userImageUrl ?? '',
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
                              errorWidget: (context, url, dynamic error) =>
                                  Image.asset(
                                'assets/images/no_user.jpg',
                              ),
                            )
                          : ClipOval(
                              child: Image.asset(
                                'assets/images/no_user.jpg',
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          createdTime?.toJPString() ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                child: Text(
                                  userName ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              child: const Text(
                                ' のお題：',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  (menuList != null && menuList!.isNotEmpty)
                      ? IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            showModalBottomSheet<int>(
                              context: context,
                              builder: (BuildContext _context) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: menuList!.map(
                                      (element) {
                                        return ListTile(
                                          leading: element.leading,
                                          title: element.title,
                                          onTap: () {
                                            if (element.onTap != null) {
                                              element.onTap!();
                                            }
                                            Navigator.of(_context).pop();
                                          },
                                        );
                                      },
                                    ).toList(),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Container(),
                ],
              ),
              Container(
                height: 16,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              (imageUrl != null && imageUrl!.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: GestureDetector(
                        onTap: onTapImage,
                        child: Hero(
                          tag: imageTag ?? '',
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            imageUrl: imageUrl ?? '',
                            errorWidget: (context, url, dynamic error) =>
                                Image.asset(
                              'assets/images/no_image.jpg',
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
