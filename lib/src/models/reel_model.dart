import 'dart:io';
import 'dart:typed_data';

import 'package:reels_viewer/reels_viewer.dart';
import 'package:video_player/video_player.dart';

abstract class ReelModel {
  final String id;
  final bool isLiked;
  final int likeCount;
  final String userName;
  final String? profileUrl;
  final String? reelDescription;
  final String? musicName;
  final List<ReelCommentModel>? commentList;
  ReelModel({
    required this.id,
    required this.userName,
    this.isLiked = false,
    this.likeCount = 0,
    this.profileUrl,
    this.reelDescription,
    this.musicName,
    this.commentList,
  });
}

class VideoReelModel extends ReelModel {
  final dynamic dataSource;
  final DataSourceType dataSourceType;

  VideoReelModel.file(
    File file, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
  })  : dataSource = file,
        dataSourceType = DataSourceType.file;

  VideoReelModel.asset(
    this.dataSource, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
  }) : dataSourceType = DataSourceType.asset;

  VideoReelModel.network(
    String url, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
  })  : dataSource = Uri.parse(url),
        dataSourceType = DataSourceType.network;

  VideoReelModel.contentUri(
    Uri contentUri, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
  })  : dataSource = contentUri,
        dataSourceType = DataSourceType.contentUri;
}

class ImageReelModel extends ReelModel {
  final dynamic dataSource;
  final DataSourceType dataSourceType;
  final Duration? duration;

  ImageReelModel.file(
    File file, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
    this.duration,
  })  : dataSource = file,
        dataSourceType = DataSourceType.file;

  ImageReelModel.asset(
    this.dataSource, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
    this.duration,
  }) : dataSourceType = DataSourceType.asset;

  ImageReelModel.network(
    String url, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
    this.duration,
  })  : dataSource = url,
        dataSourceType = DataSourceType.network;

  ImageReelModel.memory(
    Uint8List bytes, {
    required super.userName,
    required super.id,
    super.isLiked = false,
    super.likeCount = 0,
    super.profileUrl,
    super.reelDescription,
    super.musicName,
    super.commentList,
    this.duration,
  })  : dataSource = bytes,
        dataSourceType = DataSourceType.contentUri;
}
