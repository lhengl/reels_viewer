import 'package:flutter/material.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/components/user_profile_image.dart';
import 'package:reels_viewer/src/utils/convert_numbers_to_short.dart';

import 'comment_bottomsheet.dart';

class ScreenOptions extends StatelessWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(String)? onShare;
  final Function(String)? onLike;
  final Function(String)? onComment;
  final Function()? onClickMoreBtn;
  final Function()? onFollow;
  final Function()? loadMore;

  const ScreenOptions({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onFollow,
    this.onLike,
    this.onShare,
    this.loadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildLeftColumn(context),
              ),
              _buildRightColumn(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 110),
          _buildProfileRow(),
          const SizedBox(width: 6),
          if (item.reelDescription != null) _buildDescriptionRow(),
          const SizedBox(height: 10),
          if (item.musicName != null) _buildMusicRow(),
        ],
      ),
    );
  }

  Row _buildProfileRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        item.profileUrl != null
            ? UserProfileImage(profileUrl: item.profileUrl!)
            : const CircleAvatar(
                child: Icon(Icons.person, size: 18),
                radius: 16,
              ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            item.userName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        if (showVerifiedTick)
          const Icon(
            Icons.verified,
            size: 15,
            color: Colors.white,
          ),
        if (showVerifiedTick) const SizedBox(width: 6),
        if (onFollow != null)
          TextButton(
            onPressed: onFollow,
            child: const Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Text _buildDescriptionRow() {
    return Text(item.reelDescription ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(
          color: Colors.white,
        ));
  }

  Row _buildMusicRow() {
    return Row(
      children: [
        const Icon(
          Icons.music_note,
          size: 15,
          color: Colors.white,
        ),
        Text(
          'Original Audio - ${item.musicName}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      children: [
        if (onLike != null && !item.isLiked)
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.white),
            onPressed: () => onLike!(item.id),
          ),
        if (item.isLiked) const Icon(Icons.favorite_rounded, color: Colors.red),
        Text(NumbersToShort.convertNumToShort(item.likeCount), style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        IconButton(
          icon: const Icon(Icons.comment_rounded, color: Colors.white),
          onPressed: () {
            if (onComment != null) {
              showModalBottomSheet(
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (ctx) => CommentBottomSheet(
                        commentList: item.commentList ?? [],
                        onComment: onComment,
                      ));
            }
          },
        ),
        Text(
          NumbersToShort.convertNumToShort(item.commentList?.length ?? 0),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        if (onShare != null)
          InkWell(
            onTap: () => onShare!(item.id),
            child: Transform(
              transform: Matrix4.rotationZ(5.8),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (onClickMoreBtn != null)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onClickMoreBtn!,
            color: Colors.white,
          ),
      ],
    );
  }
}
