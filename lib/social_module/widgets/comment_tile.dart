// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class CommentTile extends StatefulWidget {
  final String userName;
  final String commentText;
  final String timeofcomment;
  final String usercommentImage;
  final String postID;

  const CommentTile(
      {super.key,
      required this.userName,
      required this.commentText,
      required this.timeofcomment,
      required this.usercommentImage,
      required this.postID});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.usercommentImage),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 4, // Add elevation for a shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Add border radius
                side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1), // Add border color and width
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.userName,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      widget.commentText,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.timeofcomment,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
