import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oogiri_taizen/app/view_data/block_user_list_card_view_data.dart';

class BlockUserListCardWidget extends HookWidget {
  const BlockUserListCardWidget({
    required this.viewData,
    this.onTap,
  });

  final BlockUserListCardViewData viewData;
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
                child: Text(
                  viewData.userName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
