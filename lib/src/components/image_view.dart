import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:reels_viewer/src/components/loading_widget.dart';
import 'package:reels_viewer/src/models/reel_model.dart';
import 'package:video_player/video_player.dart';

class ImageView extends StatelessWidget {
  final ImageReelModel item;
  final SwiperController swiperController;
  final bool showProgressIndicator;
  final bool looping;

  const ImageView({
    super.key,
    required this.item,
    required this.swiperController,
    this.showProgressIndicator = true,
    this.looping = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildImage(context),
        if (showProgressIndicator)
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: ImageProgressIndicator(
              duration: item.duration,
              swiperController: swiperController,
              looping: looping,
            ),
          ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final dataSource = item.dataSource;
    final dataSourceType = item.dataSourceType;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    switch (dataSourceType) {
      case DataSourceType.asset:
        return Image.asset(
          dataSource,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      case DataSourceType.network:
        return CachedNetworkImage(
          width: width,
          height: height,
          imageUrl: dataSource,
          fit: BoxFit.cover,
          placeholder: (_, __) => const LoadingWidget(),
        );
      case DataSourceType.file:
        return Image.file(
          dataSource,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );

      case DataSourceType.contentUri:
        return Image.memory(
          dataSource,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
    }
  }
}

class ImageProgressIndicator extends StatefulWidget {
  const ImageProgressIndicator({
    super.key,
    required this.duration,
    required this.swiperController,
    this.looping = true,
  });

  final SwiperController swiperController;
  final Duration duration;
  final bool looping;

  @override
  State<ImageProgressIndicator> createState() => _ImageProgressIndicatorState();
}

class _ImageProgressIndicatorState extends State<ImageProgressIndicator> {
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;
  final Duration _interval = const Duration(milliseconds: 100);

  double get progressValue => _elapsedTime.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_interval, (Timer t) {
      setState(() {
        _elapsedTime = _elapsedTime + _interval;
        if (progressValue > 1.0) {
          if (widget.looping) {
            _elapsedTime = Duration.zero;
          } else {
            widget.swiperController.next();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.blueGrey,
      color: Colors.blueAccent,
      value: progressValue,
    );
  }
}
