//post card is post

// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:social_fit/social_module/widgets/comments_bottom_sheet.dart';
import 'package:social_fit/social_module/widgets/common/common.dart';
import 'package:social_fit/social_module/widgets/loading_image_widget.dart';
import 'package:social_fit/social_module/widgets/post_button.dart';

class ProfilePostCard extends StatefulWidget {
  final String? imageofUser;
  final String timeofPost;
  final String userBio;
  final String postText;
  final String userEmail;
  final String userName;
  final String postID;
  final int backgroundColor;
  final String? postImage;
  final List<String> likes;
  const ProfilePostCard({
    super.key,
    this.imageofUser,
    required this.timeofPost,
    required this.userBio,
    required this.postText,
    required this.userEmail,
    required this.userName,
    required this.postID,
    required this.backgroundColor,
    this.postImage,
    required this.likes,
  });

  @override
  State<ProfilePostCard> createState() => _PostCardState();
}

class _PostCardState extends State<ProfilePostCard> {
  bool isLiked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  int? numberOfComments;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);

    print('Hello  + ${widget.imageofUser}');
    print('Hello  + ${widget.userName}');
    //if the current email is in List of Like, isLiked will be true
  }

  void toggleLikes() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobileCard = _mobileCard(context);
    final tabletCard = _tabletCard(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: context.responsive<Widget>(
        sm: mobileCard,
        md: tabletCard,
      ),
    );
  }

  Widget _mobileCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (widget.userEmail == currentUser.email) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          color: const Color(0xffE7E7F2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                // onTap: () => context.push(route: ProfilePage.route(post.owner)),
                leading: CircleAvatar(
                  // Adjust the size as needed
                  backgroundColor: Colors
                      .black, // Background color when image is not available
                  backgroundImage: widget.imageofUser != null
                      ? NetworkImage(widget.imageofUser!)
                      : null, // Set backgroundImage to null when image is not available
                  child: widget.imageofUser == null
                      ? const Icon(Icons.person,
                          color: Colors.white) // Placeholder icon
                      : null, // Set child to null when image is available
                ),
                title: Text(
                  widget.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Pakistan',
                  style: textTheme.bodySmall,
                ),
                trailing: widget.userEmail == currentUser.email
                    ? IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: const Color(0xffE7E7F2),
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // ListTile(
                                  //   leading:
                                  //       const Icon(EneftyIcons.edit_2_outline),
                                  //   title: Text(
                                  //     'Edit Post',
                                  //     style: GoogleFonts.poppins(
                                  //       fontSize: 16,
                                  //     ),
                                  //   ),
                                  //   onTap: () {
                                  //     Navigator.pop(context);

                                  //     // Add your edit post logic here
                                  //   },
                                  // ),
                                  ListTile(
                                    leading: const Icon(
                                      EneftyIcons.box_remove_outline,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Delete Post',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showDeleteConfirmationDialog(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : null,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(widget.postText),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: _postImage(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _postButtons(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    RoundedLoadingButtonController controller =
        RoundedLoadingButtonController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffE7E7F2),
          title: const Text('Confirmation'),
          content: const Text('Are you sure to delete?'),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel button
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                RoundedLoadingButton(
                    color: const Color(0xffE7E7F2),
                    width: 200,
                    controller: controller,
                    onPressed: () async {
                      final commentDocs = await FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(widget.postID)
                          .collection('Comments')
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection('User Posts')
                            .doc(widget.postID)
                            .collection('Comments')
                            .doc(doc.id)
                            .delete();
                      }

                      FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(widget.postID)
                          .delete()
                          .then((value) {
                        Get.snackbar('Post', 'Successfully Deleted',
                            margin: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            backgroundColor: Colors.green,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM);
                      });

                      controller.stop();

                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'Delete',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ))
              ],
            )

            // ElevatedButton(
            //   onPressed: () async {
            //     // Perform delete operation here
            //     // ...

            //     final commentDocs = await FirebaseFirestore.instance
            //         .collection('User Posts')
            //         .doc(widget.postID)
            //         .collection('Comments')
            //         .get();

            //     for (var doc in commentDocs.docs) {
            //       await FirebaseFirestore.instance
            //           .collection('User Posts')
            //           .doc(widget.postID)
            //           .collection('Comments')
            //           .doc(doc.id)
            //           .delete();
            //     }

            //     FirebaseFirestore.instance
            //         .collection('User Posts')
            //         .doc(widget.postID)
            //         .delete()
            //         .then((value) {
            //       Get.snackbar('Post', 'Successfully Deleted',
            //           margin: const EdgeInsets.only(
            //             bottom: 10,
            //             left: 10,
            //             right: 10,
            //           ),
            //           backgroundColor: Colors.green,
            //           borderRadius: 12,
            //           snackPosition: SnackPosition.BOTTOM);
            //     });

            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   child: Text(
            //     'Delete',
            //     style: GoogleFonts.poppins(
            //         fontWeight: FontWeight.bold, color: Colors.red),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget _tabletCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _postImage(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          // onTap: () => context.push(
                          //   route: ProfilePage.route(post.owner),
                          // ),
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            // Adjust the size as needed
                            backgroundColor: Colors
                                .black, // Background color when image is not available
                            backgroundImage: widget.imageofUser != null
                                ? NetworkImage(widget.imageofUser!)
                                : null, // Set backgroundImage to null when image is not available
                            child: widget.imageofUser == null
                                ? const Icon(Icons.person,
                                    color: Colors.white) // Placeholder icon
                                : null, // Set child to null when image is available
                          ),
                          title: Text(
                            widget.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            'Pakistan',
                            style: textTheme.bodySmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(widget.postText),
                        ),
                      ],
                    ),
                    _postButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postImage() {
    if (widget.postImage == null) {
      return const SizedBox
          .shrink(); // Return an empty container or a placeholder widget
    }
    return Image.network(
      widget.postImage!,
      fit: BoxFit.fitWidth,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return const AspectRatio(
          aspectRatio: 4 / 3,
          child: LoadingImageWidget(),
        );
      },
      errorBuilder: (ctx, _, __) {
        return const SizedBox.shrink();
      },
    );
  }

  Widget _postButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _ToggleButton(
            isActive: isLiked,
            count: widget.likes.length,
            iconData: Icons.favorite_outline,
            activeIconData: Icons.favorite,
          ),
        ),
        Expanded(
          child: _CommentButton(
            postID: widget.postID,
            commentImage: widget.imageofUser!,
          ),
        ),
        // Expanded(
        //   child: _ToggleButton(
        //     isActive: post.isSaved,
        //     count: post.saveCount,
        //     iconData: Icons.bookmark_add_outlined,
        //     activeIconData: Icons.bookmark_added,
        //   ),
        // ),

        //check share issues

        Expanded(
          child: IconButton(
              onPressed: () {}, icon: const Icon(EneftyIcons.send_2_outline)),
        ),
      ],
    );
  }
}

class _CommentButton extends StatefulWidget {
  final String postID;
  final String commentImage;
  const _CommentButton({required this.postID, required this.commentImage});

  @override
  State<_CommentButton> createState() => _CommentButtonState();
}

class _CommentButtonState extends State<_CommentButton> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int? numberOfComments;

  Future<void> getCommentsCount() async {
    QuerySnapshot commentDocs = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .get();

    setState(() {
      numberOfComments = commentDocs.size;
    });
  }

  // void addComments(String commentText) async {
  //   FirebaseFirestore.instance
  //       .collection('User Posts')
  //       .doc(widget.postID)
  //       .collection('Comments')
  //       .add({
  //     'comments': commentText,
  //     'commentby': currentUser.email,
  //     'commenttime': Timestamp.now(), //decorate it
  //   });
  //   await getCommentsCount();
  // }

  @override
  void initState() {
    super.initState();
    getCommentsCount();
  }

  @override
  Widget build(BuildContext context) {
    return PostButton(
        icon: const Icon(Icons.chat_bubble_outline),
        text: numberOfComments.toString(),
        onTap: () => CommentsBottomSheet.showCommentsBottomSheet(
              context,
              widget.postID,
              widget.commentImage,
            ).then((_) {
              setState(() {
                getCommentsCount(); // Call the method here instead of directly passing it to setState
              });
            }));
  }
}

/// Like and Save button
class _ToggleButton extends StatefulWidget {
  const _ToggleButton({
    this.count = 0,
    required this.iconData,
    required this.activeIconData,
    required this.isActive,
  });

  final IconData iconData;
  final IconData activeIconData;
  final int count;
  final bool isActive;

  @override
  State<_ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton>
    with AutomaticKeepAliveClientMixin {
  late bool _isActive;
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
    _isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return PostButton(
      icon: Icon(
        _isActive ? widget.activeIconData : widget.iconData,
        color: _isActive ? theme.colorScheme.primary : null,
      ),
      text: _count.toString(),
      onTap: () => setState(() {
        _isActive = !_isActive;
        _isActive ? _count++ : _count--;
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
