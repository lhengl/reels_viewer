import 'package:reels_viewer/reels_viewer.dart';

typedef OnReelLike = void Function(String realId);

typedef OnReelShare = void Function(String comment);

typedef OnReelComment = void Function(String realId);

typedef FetchReelComments = Future<List<ReelCommentModel>> Function(
  ReelModel reel,
  int pageSize,
);

typedef OnReelFollow = void Function();

typedef OnMoreButtonTap = void Function();

typedef OnIndexChanged = void Function(int);

typedef OnBackButtonTap = void Function();
