import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/src/components/image_reel_view.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:reels_viewer/src/reels_page.dart';

class ReelsViewer extends StatefulWidget {
  /// use reel model and provide list of reels, list contains reels object, object contains url and other parameters
  final List<ReelModel> reelsList;

  /// for change appbar title
  final String? appbarTitle;

  /// function invoke when user click on like btn and return reel url
  final Function(String)? onLike;

  /// function invoke when user click on comment btn and return reel comment
  final Function(String)? onComment;

  /// function invoke when user click on share btn and return reel url
  final Function(String)? onShare;

  /// function invoke when user click on more options btn
  final Function()? onClickMoreBtn;

  /// function invoke when user click on follow btn
  final Function()? onFollow;

  /// function invoke when user click on back btn
  final Function()? onClickBackArrow;

  /// function invoke when reel change and return current index
  final Function(int)? onIndexChanged;

  final Function()? loadMoreComments;

  /// for show/hide appbar, by default true
  final bool showAppbar;

  /// for show/hide video progress indicator, by default true
  final bool showProgressIndicator;

  /// use to show/hide verified tick, by default true
  final bool showVerifiedTick;

  /// Plays the next item automatically when true. Defaults to false.
  /// Both [videoLoop] and [autoplay] cannot be true.
  final bool autoplay;

  /// Loops videos if true. Defaults to true.
  /// Both [videoLoop] and [autoplay] cannot be true.
  final bool videoLoop;

  /// Loops reel list if true. Defaults to false.
  /// Note: When working with dynamic list of items, leave this as false.
  /// There is a bug in card_swiper package, where adding items to the list
  /// while swiping in reverse order will lead to unexpected behaviour:
  /// https://github.com/TheAnkurPanchani/card_swiper/issues/96
  final bool swiperLoop;

  /// The default duration of a still image. Defaults to 5 seconds.
  /// For performance reason, it must be at least 2 seconds.
  /// See: [ImageReelView.minDuration]
  final Duration defaultImageDuration;

  const ReelsViewer({
    Key? key,
    required this.reelsList,
    this.appbarTitle,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onClickMoreBtn,
    this.onFollow,
    this.loadMoreComments,
    this.onClickBackArrow,
    this.onIndexChanged,
    this.showAppbar = true,
    this.showProgressIndicator = true,
    this.showVerifiedTick = true,
    this.autoplay = false,
    this.videoLoop = true,
    this.swiperLoop = false,
    this.defaultImageDuration = const Duration(seconds: 5),
  })  : assert(!(autoplay && videoLoop), 'Only one of autoplay or looping can be true'),
        super(key: key);

  @override
  State<ReelsViewer> createState() => _ReelsViewerState();
}

class _ReelsViewerState extends State<ReelsViewer> {
  final SwiperController controller = SwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: SafeArea(
        child: Stack(
          children: [
            //We need swiper for every content
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return ReelsPage(
                  item: widget.reelsList[index],
                  onClickMoreBtn: widget.onClickMoreBtn,
                  onComment: widget.onComment,
                  onFollow: widget.onFollow,
                  onLike: widget.onLike,
                  onShare: widget.onShare,
                  loadMore: widget.loadMoreComments,
                  showVerifiedTick: widget.showVerifiedTick,
                  swiperController: controller,
                  showProgressIndicator: widget.showProgressIndicator,
                  looping: widget.videoLoop,
                  autoplay: widget.autoplay,
                  defaultImageDuration: widget.defaultImageDuration,
                );
              },
              controller: controller,
              itemCount: widget.reelsList.length,
              scrollDirection: Axis.vertical,
              onIndexChanged: widget.onIndexChanged,
              loop: widget.swiperLoop,
            ),
            if (widget.showAppbar)
              Container(
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: widget.onClickBackArrow ?? () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Text(
                      widget.appbarTitle ?? 'Reels View',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
