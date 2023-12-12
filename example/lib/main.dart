import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reels_viewer/reels_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reels Viewer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ReelModel> reelsList = [
    VideoReelModel.network('https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
        id: 'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
        userName: 'Darshan Patil',
        likeCount: 2000,
        isLiked: true,
        musicName: 'In the name of Love',
        reelDescription: "Life is better when you're laughing.",
        profileUrl: 'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
        commentList: [
          ReelCommentModel(
            comment: 'Nice...',
            userProfilePic: 'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
            userName: 'Darshan',
            commentTime: DateTime.now(),
          ),
          ReelCommentModel(
            comment: 'Superr...',
            userProfilePic: 'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
            userName: 'Darshan',
            commentTime: DateTime.now(),
          ),
          ReelCommentModel(
            comment: 'Great...',
            userProfilePic: 'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
            userName: 'Darshan',
            commentTime: DateTime.now(),
          ),
        ]),
    VideoReelModel.network(
      'https://assets.mixkit.co/videos/preview/mixkit-father-and-his-little-daughter-eating-marshmallows-in-nature-39765-large.mp4',
      id: 'https://assets.mixkit.co/videos/preview/mixkit-father-and-his-little-daughter-eating-marshmallows-in-nature-39765-large.mp4',
      userName: 'Rahul',
      musicName: 'In the name of Love',
      reelDescription: "Life is better when you're laughing.",
      profileUrl: 'https://opt.toiimg.com/recuperator/img/toi/m-69257289/69257289.jpg',
    ),
    VideoReelModel.network(
      'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
      id: 'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
      userName: 'Rahul',
    ),
    VideoReelModel.asset(
      'assets/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4',
      userName: 'VideoReelModel.asset',
      id: 'assets/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4',
      reelDescription: "assets/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4",
    ),
    ImageReelModel.network(
      'https://unsplash.com/photos/lokx3ilDIpM/download?ixid=M3wxMjA3fDB8MXxhbGx8MTV8fHx8fHwyfHwxNzAyMzU3MjM0fA&force=true&w=640',
      id: 'https://unsplash.com/photos/lokx3ilDIpM/download?ixid=M3wxMjA3fDB8MXxhbGx8MTV8fHx8fHwyfHwxNzAyMzU3MjM0fA&force=true&w=640',
      userName: 'ImageReelModel.network',
      reelDescription: "https://unsplash.com/photos/lokx3ilDIpM/download?ixid=M3wxMjA3fDB8MXxhbGx8MTV8fHx8fHwyfHwxNzAyMzU3MjM0fA&force=true&w=64",
    ),
    ImageReelModel.asset(
      'assets/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg',
      userName: 'ImageReelModel.asset',
      id: 'assets/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg',
      reelDescription: "melody-zimmerman-hlAoUJsSg1M-unsplash.jpg",
    ),
    VideoReelModel.network(
      'invalidVideoUrl',
      id: 'invalidVideoUrl',
      userName: 'invalidVideoUrl',
    ),
    VideoReelModel.asset(
      'invalidVideoAsset',
      id: 'invalidVideoAsset',
      userName: 'invalidVideoAsset',
    ),
    ImageReelModel.network(
      'invalidImageUrl',
      id: 'invalidImageUrl',
      userName: 'invalidImageUrl',
    ),
    ImageReelModel.asset(
      'invalidImageAsset',
      id: 'invalidImageAsset',
      userName: 'invalidImageAsset',
    ),
  ];

  bool _isInitialised = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  /// Writing sample assets as files for testing purposes
  Future<void> init() async {
    final tmpDir = await getTemporaryDirectory();
    final sampleVideoBytes = (await rootBundle.load('assets/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4')).buffer.asUint8List();
    final sampleImageBytes = (await rootBundle.load('assets/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg')).buffer.asUint8List();
    final sampleVideoFile = File('${tmpDir.path}/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4');
    final sampleImageFile = File('${tmpDir.path}/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg');
    await sampleVideoFile.writeAsBytes(sampleVideoBytes);
    await sampleImageFile.writeAsBytes(sampleImageBytes);
    reelsList.addAll([
      VideoReelModel.file(
        sampleVideoFile,
        userName: 'VideoReelModel.file',
        id: 'file/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4',
        reelDescription: "file/mixkit-orange-slices-over-a-white-backdrop-50803-medium.mp4",
      ),
      ImageReelModel.file(
        sampleImageFile,
        userName: 'ImageReelModel.file',
        id: 'file/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg',
        reelDescription: "file/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg",
      ),
      ImageReelModel.memory(
        sampleImageBytes,
        userName: 'ImageReelModel.memory',
        id: 'memory/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg',
        reelDescription: "memory/melody-zimmerman-hlAoUJsSg1M-unsplash.jpg",
      ),
    ]);
    setState(() {
      _isInitialised = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialised
        ? ReelsViewer(
            reelsList: reelsList,
            appbarTitle: 'Instagram Reels',
            onShare: (url) {
              log('Shared reel url ==> $url');
            },
            onLike: (url) {
              log('Liked reel url ==> $url');
            },
            onFollow: () {
              log('======> Clicked on follow <======');
            },
            onComment: (comment) {
              log('Comment on reel ==> $comment');
            },
            onClickMoreBtn: () {
              log('======> Clicked on more option <======');
            },
            onClickBackArrow: () {
              log('======> Clicked on back arrow <======');
            },
            onIndexChanged: (index) {
              log('======> Current Index ======> $index <========');
            },
            showProgressIndicator: true,
            showVerifiedTick: true,
            showAppbar: true,
            autoplay: false,
            looping: true,
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
