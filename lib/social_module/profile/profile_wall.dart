// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_fit/social_module/utils/comment_button.dart';
import 'package:social_fit/social_module/utils/comments.dart';
import 'package:social_fit/social_module/utils/like_button.dart';
import 'package:social_fit/social_module/utils/reuse_textfield.dart';
import 'package:social_fit/social_module/utils/time.dart';
import 'package:share_plus/share_plus.dart';

class PostDesignforProfile extends StatefulWidget {
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
  const PostDesignforProfile(
      {super.key,
      required this.postID,
      required this.likes,
      this.imageofUser,
      required this.timeofPost,
      required this.postText,
      required this.userName,
      this.postImage,
      required this.backgroundColor,
      required this.userEmail,
      required this.userBio});

  @override
  State<PostDesignforProfile> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesignforProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final commentTextController = TextEditingController();
  int? numberOfComments;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    getCommentsCount();
    toggleLikes();

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

  void addComments(String commentText) async {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .add({
      'comments': commentText,
      'commentby': currentUser.email,
      'commenttime': Timestamp.now(), //decorate it
    });
    await getCommentsCount();
  }

  void showCommentsDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xffE7E7F2),
              title: const Text('Add Comments'),
              content: ReuseTextField(
                  emailLogin: commentTextController,
                  prefixIcon: const Icon(EneftyIcons.message_2_outline),
                  emailLabel: 'Enter The Comment..',
                  isObscure: false),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                  onPressed: () {
                    addComments(commentTextController.text);
                    Get.back();
                    commentTextController.clear();
                    //fill it
                  },
                  child: Text('Comment',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userEmail == currentUser.email) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xffE7E7F2),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25, // Adjust the size as needed
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
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '"${widget.userBio}"',
                        style: GoogleFonts.jacquesFrancois(
                            fontSize: 10, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.userEmail == currentUser.email)
                    IconButton(
                      icon: const Icon(
                          EneftyIcons.more_2_outline), //options icons
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: const Color(0xffE7E7F2),
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      const Icon(EneftyIcons.edit_2_outline),
                                  title: Text(
                                    'Edit Post',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);

                                    // Add your edit post logic here
                                  },
                                ),
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
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.postText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              widget.postImage != ''
                  ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.postImage!),
                          fit: BoxFit.cover,
                        ),
                      ))
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              //EDIT THIS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' · ${widget.timeofPost}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.userEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 5,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        LikeButton(isLiked: isLiked, onTap: toggleLikes),
                        Text(
                          widget.likes.length.toString(),
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Column(
                      children: [
                        CommentButton(onTap: () {
                          showCommentsDialog();
                        }),
                        if (numberOfComments != null && numberOfComments != 0)
                          Text(
                            //comment counter
                            numberOfComments.toString(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                        if (numberOfComments == null || numberOfComments == 0)
                          Text(
                            //comment counter
                            '0',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(EneftyIcons.share_outline),
                      onPressed: () {
                        Share.share('Check out this post: ${widget.postText}');
                      },
                    ),
                  ],
                ),
              ),
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

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        final commentData = doc.data();
                        String formattedTimestamp =
                            TimeFormatter.formatTimestamp(
                                commentData['commenttime']);

                        return Comments(
                            message: commentData['comments'],
                            user: commentData['commentby'],
                            time: formattedTimestamp);
                      }).toList(), // why we return tolist here
                    );
                  })
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffE7E7F2),
          title: const Text('Confirmation'),
          content: const Text('Are you sure to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Perform delete operation here
                // ...

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

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
