import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/src/components/video_reel_view.dart';
import 'package:reels_viewer/src/models/reel_model.dart';

import 'components/image_reel_view.dart';
import 'components/like_icon.dart';
import 'components/screen_options.dart';

class ReelsPage extends StatefulWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(String)? onShare;
  final Function(String)? onLike;
  final Function(String)? onComment;
  final Function()? onClickMoreBtn;
  final Function()? onFollow;
  final SwiperController swiperController;
  final bool showProgressIndicator;
  final bool autoplay;
  final bool looping;
  final Duration defaultImageDuration;
  final Widget? background;

  const ReelsPage({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onFollow,
    this.onLike,
    this.onShare,
    this.showProgressIndicator = true,
    required this.swiperController,
    required this.autoplay,
    required this.looping,
    required this.defaultImageDuration,
    this.background,
  })  : assert(!(autoplay && looping), 'Only one of autoplay or looping can be true'),
        super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.background != null) widget.background!,
        GestureDetector(
          onDoubleTap: () {
            if (!widget.item.isLiked) {
              _liked = true;
              if (widget.onLike != null) {
                widget.onLike!(widget.item.id);
              }
              setState(() {});
            }
          },
          child: _buildMediaLayer(),
        ),
        if (_liked)
          const Center(
            child: LikeIcon(),
          ),
        ScreenOptions(
          onClickMoreBtn: widget.onClickMoreBtn,
          onComment: widget.onComment,
          onFollow: widget.onFollow,
          onLike: widget.onLike,
          onShare: widget.onShare,
          showVerifiedTick: widget.showVerifiedTick,
          item: widget.item,
        ),
      ],
    );
  }

  Widget _buildMediaLayer() {
    final item = widget.item;
    if (item is VideoReelModel) {
      return VideoReelView(
        item: item,
        swiperController: widget.swiperController,
        showProgressIndicator: widget.showProgressIndicator,
        autoplay: widget.autoplay,
        looping: widget.looping,
      );
    } else if (item is ImageReelModel) {
      return ImageReelView(
        item: item,
        swiperController: widget.swiperController,
        showProgressIndicator: widget.showProgressIndicator,
        autoplay: widget.autoplay,
        defaultDuration: widget.defaultImageDuration,
      );
    }
    throw ArgumentError('Unexpected item type: ${item.runtimeType}');
  }
}
