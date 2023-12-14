import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/components/comment_item.dart';

import '../models/types.dart';

class CommentBottomSheet extends StatefulWidget {
  final ReelModel item;
  final Function(String)? onComment;
  final FetchReelComments? fetchComments;
  final int pageSize;
  const CommentBottomSheet({
    super.key,
    required this.item,
    required this.onComment,
    required this.fetchComments,
    required this.pageSize,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _commentController = TextEditingController(text: '');
  final _pagingController = PagingController<String?, ReelCommentModel>(firstPageKey: null);

  @override
  void initState() {
    super.initState();
    if (widget.item.commentList.isNotEmpty) {
      _pagingController.appendPage(
        widget.item.commentList,
        widget.item.commentList.lastOrNull?.id,
      );
    }
    _pagingController.addPageRequestListener((lastCommentId) {
      _fetchComments(lastCommentId);
    });
    // Load initial comments
  }

  Future<void> _fetchComments(String? lastCommentId) async {
    if (widget.fetchComments != null) {
      try {
        final fetchedComments = await widget.fetchComments!.call(
          widget.item,
          widget.pageSize,
        );
        final isLastPage = fetchedComments.length < widget.pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(fetchedComments);
        } else {
          _pagingController.appendPage(
            fetchedComments,
            fetchedComments.last.id,
          );
        }
      } catch (error) {
        _pagingController.error = error;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Text(
              'Comments',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          Expanded(
            child: PagedListView<String?, ReelCommentModel>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<ReelCommentModel>(
                itemBuilder: (context, item, index) => CommentItem(
                  commentItem: item,
                ),
                noItemsFoundIndicatorBuilder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.comment,
                        color: Theme.of(context).disabledColor,
                      ),
                      const Text('No comments yet'),
                    ],
                  );
                },
              ),
            ),
          ),
          const Divider(),
          _buildCommentTextField(context),
        ],
      ),
    );
  }

  Widget _buildCommentTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: 'Add a comment...',
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.all(10),
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          suffixIcon: InkWell(
              onTap: () {
                if (widget.onComment != null) {
                  String comment = _commentController.text;
                  widget.onComment!(comment);
                }
                Navigator.pop(context);
              },
              child: const Icon(Icons.send)),
        ),
      ),
    );
  }
}
