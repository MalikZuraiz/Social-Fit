import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_fit/social_module/widgets/common/common.dart';
import 'package:social_fit/social_module/widgets/layout/responsive_padding.dart';
import 'package:social_fit/social_module/widgets/profile_post_card.dart';

class NewProfilePage extends StatefulWidget {
  final int userfriends;
  final String userEmail;
  final String userName;
  final String userBio;
  final String userImage;
  final String userLastSeen;
  final bool userortrainer;
  final String usergender;
  final String userdob;
  final String userlevel;
  final String usergoals;
  final String userheight;
  final String userweight;
  final int userPosts;
  final String userCoverImage;

  const NewProfilePage({
    super.key,
    required this.userEmail,
    required this.userName,
    required this.userBio,
    required this.userImage,
    required this.userLastSeen,
    required this.userortrainer,
    required this.usergender,
    required this.userdob,
    required this.userlevel,
    required this.usergoals,
    required this.userheight,
    required this.userweight,
    required this.userPosts,
    required this.userfriends,
    required this.userCoverImage,
  });

  @override
  State<NewProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<NewProfilePage> {
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerAndProfilePicture(context),
            _userBio(context),
            _postsGridView(context),
          ],
        ),
      ),
    );
  }

  Widget _postsGridView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // Set a specific height
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User Posts')
            .orderBy('TimeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.docs[index];
                final postTime = (post['TimeStamp'] as Timestamp).toDate();
                final formattedTime = DateFormat.jm().format(postTime);
                return ProfilePostCard(
                  postID: post.id,
                  likes: List<String>.from(post['Likes'] ?? []),
                  imageofUser: post['UserImage'],
                  userBio: post['Bio'],
                  backgroundColor: post['backgroundColor'],
                  postImage: post['imageUrl'], //empty value
                  timeofPost: formattedTime, //hardcore value
                  postText: post['Message'],
                  userEmail: post['UserEmail'],
                  userName: post['UserName'],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Unable to load data'),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      flexibleSpace: ResponsivePadding(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed: () => context.pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withAlpha(75),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                //HERE TO UPDATE PROFILE AND COVER PAGE
                IconButton.filledTonal(
                  onPressed: () {
                    changeprofileandcoverpage();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withAlpha(75),
                  ),
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerAndProfilePicture(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.expand(height: 200),
              child: Image.network(
                widget.userCoverImage,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.userPosts.toString(),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Posts'),
                    ],
                  ),
                  const SizedBox(width: 48),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (widget.userfriends - 1).toString(),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Friends'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          width: 100,
          height: 100,
          child: FittedBox(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    widget.userImage,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _userBio(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.userName,
            style: textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(widget.userEmail, style: textTheme.bodyMedium),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fiber_manual_record_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(
                        width: 8), // Add space between the icon and text
                    Text(widget.userheight, style: textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(
                    height:
                        8), // Add some space between the bio and other information
                Row(
                  children: [
                    const Icon(Icons.fiber_manual_record_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(
                        width: 8), // Add space between the icon and text
                    Text(widget.userweight, style: textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fiber_manual_record_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(
                            width: 8), // Add space between the icon and text
                        Text(widget.usergender, style: textTheme.bodyMedium),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showDetails = !showDetails;
                        });
                      },
                      child: showDetails
                          ? const Text('')
                          : Text(
                              'Show Details',
                              style: TextStyle(color: Colors.blue[600]),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                //Button to show info

                showDetails
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fiber_manual_record_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(
                                  width:
                                      8), // Add space between the icon and text
                              Text(widget.userlevel,
                                  style: textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.fiber_manual_record_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(
                                  width:
                                      8), // Add space between the icon and text
                              Text(widget.userdob, style: textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.fiber_manual_record_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(
                                  width:
                                      8), // Add space between the icon and text
                              Text(widget.userBio, style: textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.fiber_manual_record_outlined,
                                          size: 16,
                                          color: Colors.grey),
                                      const SizedBox(
                                          width:
                                              8), // Add space between the icon and text
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          widget.usergoals,
                                          style: textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showDetails = !showDetails;
                                      });
                                    },
                                    child: showDetails
                                        ? Text(
                                            'Hide Details',
                                            style: TextStyle(
                                                color: Colors.blue[600]),
                                          )
                                        : const Text(''),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeprofileandcoverpage() {
    showModalBottomSheet(
      backgroundColor: const Color(0xffE7E7F2),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                EneftyIcons.profile_outline,
                color: Colors.red,
              ),
              title: Text(
                'Change Profile Picture',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                changeprofilepicture();
              },
            ),
            ListTile(
              leading: const Icon(
                EneftyIcons.picture_frame_outline,
                color: Colors.red,
              ),
              title: Text(
                'Change Cover Photo',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                changecoverpicture();
              },
            ),
          ],
        );
      },
    );
  }

  void changeprofilepicture() {
    showModalBottomSheet(
      backgroundColor: const Color(0xffE7E7F2),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                EneftyIcons.camera_outline,
                color: Colors.red,
              ),
              title: Text(
                'Camera',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickProfileImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                EneftyIcons.gallery_outline,
                color: Colors.red,
              ),
              title: Text(
                'Gallery',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickProfileImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (_imageFile != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      await ref.putFile(_imageFile!);
      String imageUrl = await ref.getDownloadURL();

      //parameters we are sending
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userEmail)
          .update(
        {
          'userImage': imageUrl,
        },
      );
    }
  }

  Future<void> _pickCoverImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    if (_imageFile != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      await ref.putFile(_imageFile!);
      String imageUrl = await ref.getDownloadURL();

      //parameters we are sending
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userEmail)
          .update(
        {
          'userCoverImage': imageUrl,
        },
      );
    }
  }

  void changecoverpicture() {
    showModalBottomSheet(
      backgroundColor: const Color(0xffE7E7F2),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                EneftyIcons.camera_outline,
                color: Colors.red,
              ),
              title: Text(
                'Camera',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickCoverImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                EneftyIcons.gallery_outline,
                color: Colors.red,
              ),
              title: Text(
                'Gallery',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickCoverImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
