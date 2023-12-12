import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/src/components/loading_widget.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:video_player/video_player.dart';

class VideoReelView extends StatefulWidget {
  final VideoReelModel item;
  final bool showProgressIndicator;
  final bool looping;
  final SwiperController swiperController;
  const VideoReelView({
    super.key,
    required this.item,
    required this.swiperController,
    this.showProgressIndicator = true,
    this.looping = true,
  });

  @override
  State<VideoReelView> createState() => _VideoReelViewState();
}

class _VideoReelViewState extends State<VideoReelView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialised = false;

  @override
  void initState() {
    super.initState();
    initVideoPlayer();
  }

  Future<void> initVideoPlayer() async {
    final dataSource = widget.item.dataSource;
    final dataSourceType = widget.item.dataSourceType;
    switch (dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(dataSource);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.networkUrl(dataSource);
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(dataSource);
        break;
      case DataSourceType.contentUri:
        _videoPlayerController = VideoPlayerController.contentUri(dataSource);
        break;
    }
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: widget.looping,
    );
    setState(() {});
    _videoPlayerController.addListener(() {
      if (_chewieController?.looping ?? false) return;
      if (_videoPlayerController.value.position == _videoPlayerController.value.duration) {
        widget.swiperController.next();
      }
    });
    _isInitialised = true;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoReelView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_chewieController?.looping != widget.looping) {
      _chewieController?.setLooping(widget.looping);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _isInitialised
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Chewie(controller: _chewieController!),
                ),
              )
            : const LoadingWidget(),
        if (widget.showProgressIndicator)
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: VideoProgressIndicator(
              _videoPlayerController,
              allowScrubbing: false,
              colors: const VideoProgressColors(
                backgroundColor: Colors.blueGrey,
                bufferedColor: Colors.blueGrey,
                playedColor: Colors.blueAccent,
              ),
            ),
          ),
      ],
    );
  }
}
