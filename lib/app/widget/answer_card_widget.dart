import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:oogiri_taizen/extension/date_time_extension.dart';
import 'package:oogiri_taizen/extension/int_extension.dart';

class AnswerCardWidget extends HookWidget {
  const AnswerCardWidget({
    this.userImageUrl,
    this.onTapUserImage,
    this.createdTime,
    this.userName,
    this.menuList,
    required this.text,
    this.imageUrl,
    this.imageTag,
    this.onTapImage,
    this.isLike,
    this.onTapLikeButton,
    this.likedTime,
    this.isFavor,
    this.onTapFavorButton,
    this.favoredTime,
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
  final bool? isLike;
  final void Function()? onTapLikeButton;
  final int? likedTime;
  final bool? isFavor;
  final void Function()? onTapFavorButton;
  final int? favoredTime;
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
                                ' のボケ：',
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
              (isLike == null &&
                      onTapLikeButton == null &&
                      likedTime == null &&
                      isFavor == null &&
                      onTapFavorButton == null &&
                      favoredTime == null)
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              (isLike == null && onTapLikeButton == null)
                                  ? Container()
                                  : IconButton(
                                      icon: (isLike ?? false)
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.pink,
                                            )
                                          : const Icon(
                                              Icons.favorite_outline,
                                              color: Colors.pink,
                                            ),
                                      onPressed: () {
                                        if (onTapLikeButton != null) {
                                          onTapLikeButton!();
                                        }
                                      },
                                    ),
                              (likedTime == null)
                                  ? Container()
                                  : Text(
                                      likedTime!.toStringOverTenThousand(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              (isFavor == null && onTapFavorButton == null)
                                  ? Container()
                                  : IconButton(
                                      icon: (isFavor ?? false)
                                          ? const Icon(
                                              Icons.star,
                                              color: Colors.cyan,
                                            )
                                          : const Icon(
                                              Icons.star_outline,
                                              color: Colors.cyan,
                                            ),
                                      onPressed: () {
                                        if (onTapFavorButton != null) {
                                          onTapFavorButton!();
                                        }
                                      },
                                    ),
                              (favoredTime == null)
                                  ? Container()
                                  : Text(
                                      favoredTime!.toStringOverTenThousand(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
