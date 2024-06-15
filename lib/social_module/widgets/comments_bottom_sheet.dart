import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_fit/social_module/utils/time.dart';
import 'package:social_fit/social_module/widgets/comment_tile.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postID;
  final String commentImage;

  const CommentsBottomSheet(
      {super.key, required this.postID, required this.commentImage});

  static Future<void> showCommentsBottomSheet(
      BuildContext context, String postID, String commentImage) async {
    return await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
      isScrollControlled: true,
      builder: (_) =>
          CommentsBottomSheet(postID: postID, commentImage: commentImage),
    );
  }

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('User Posts')
              .doc(widget.postID)
              .collection('Comments')
              .orderBy("commenttime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 64),
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: const EdgeInsets.only(bottom: 64),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data();
                    String formattedTimestamp = TimeFormatter.formatTimestamp(
                        commentData['commenttime']);

                    return CommentTile(
                      usercommentImage: commentData['commentImage'],
                      timeofcomment: formattedTimestamp,
                      commentText: commentData['comments'],
                      userName: commentData['commentby'],
                      postID: widget.postID,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _header(theme),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _commentTextField(theme),
        ),
      ],
    );
  }

  Widget _header(ThemeData theme) {
    return SizedBox(
      height: 64,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: theme.dividerColor.withAlpha(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Comments',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentTextField(ThemeData theme) {
    TextEditingController controller = TextEditingController();

    return Container(
      color: theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: addComments,
              decoration: InputDecoration(
                hintText: 'Enter the comment',
                filled: true,
                isDense: true,
                fillColor: theme.colorScheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {
              if (controller.text.isEmpty) return;
              addComments(controller.text);
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void addComments(String commentText) async {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .add({
      'comments': commentText,
      'commentby': currentUser.email,
      'commenttime': Timestamp.now(),
      'commentImage': widget.commentImage,
      'commentLikes': [],
    });
  }
}
