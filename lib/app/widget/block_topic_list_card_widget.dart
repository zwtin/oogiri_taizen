import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oogiri_taizen/app/view_data/block_topic_list_card_view_data.dart';
import 'package:oogiri_taizen/extension/date_time_extension.dart';

class BlockTopicListCardWidget extends HookWidget {
  const BlockTopicListCardWidget({
    required this.viewData,
    this.onTap,
    this.onTapImage,
  });

  final BlockTopicListCardViewData viewData;
  final void Function()? onTap;
  final void Function()? onTapImage;

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
                  SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }
}
