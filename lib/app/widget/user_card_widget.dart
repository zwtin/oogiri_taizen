import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:oogiri_taizen/extension/date_time_extension.dart';

class UserCardWidget extends HookWidget {
  const UserCardWidget({
    this.userImageUrl,
    this.onTapUserImage,
    required this.userName,
    this.onTap,
  });

  final String? userImageUrl;
  final void Function()? onTapUserImage;
  final String userName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          imageBuilder: (context, imageProvider) => Container(
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
              Flexible(
                child: Container(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    overflow: TextOverflow.ellipsis,
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
