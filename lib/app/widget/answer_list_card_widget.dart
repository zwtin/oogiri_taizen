import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oogiri_taizen/app/view_data/answer_list_card_view_data.dart';
import 'package:oogiri_taizen/extension/date_time_extension.dart';
import 'package:oogiri_taizen/extension/int_extension.dart';

class AnswerListCardWidget extends HookWidget {
  const AnswerListCardWidget({
    required this.viewData,
    this.menuList,
    this.onTapUserImage,
    this.onTapImage,
    this.onTapLikeButton,
    this.onTapFavorButton,
    this.onTap,
  });

  final AnswerListCardViewData viewData;
  final List<ListTile>? menuList;
  final void Function()? onTapUserImage;
  final void Function()? onTapImage;
  final void Function()? onTapLikeButton;
  final void Function()? onTapFavorButton;
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
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        imageUrl: viewData.userImageUrl ?? '',
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, dynamic error) {
                          return ClipOval(
                            child: Image.asset(
                              'assets/images/no_user.jpg',
                            ),
                          );
                        },
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
                          viewData.createdTime.toJPString(),
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
                                  viewData.userName,
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
                  Visibility(
                    visible: menuList?.isNotEmpty ?? false,
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        showModalBottomSheet<int>(
                          context: context,
                          builder: (BuildContext _context) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
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
                    ),
                  ),
                ],
              ),
              Container(
                height: 16,
              ),
              Text(
                viewData.text,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Visibility(
                visible: viewData.imageUrl != null &&
                    viewData.imageUrl!.isNotEmpty &&
                    viewData.imageTag != null &&
                    viewData.imageTag!.isNotEmpty,
                child: Column(
                  children: [
                    Container(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: onTapImage,
                      child: Hero(
                        tag: viewData.imageTag!,
                        child: CachedNetworkImage(
                          placeholder: (context, url) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          imageUrl: viewData.imageUrl!,
                          errorWidget: (context, url, dynamic error) {
                            return Image.asset(
                              'assets/images/no_image.jpg',
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          icon: viewData.isLike
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.pink,
                                ),
                          onPressed: onTapLikeButton,
                        ),
                        Text(
                          viewData.likedCount.toStringOverTenThousand(),
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
                        IconButton(
                          icon: viewData.isFavor
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.cyan,
                                )
                              : const Icon(
                                  Icons.star_outline,
                                  color: Colors.cyan,
                                ),
                          onPressed: onTapFavorButton,
                        ),
                        Text(
                          viewData.favoredCount.toStringOverTenThousand(),
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
