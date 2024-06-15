import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:social_fit/social_module/new_profile/profile_page.dart';

class ProfileView extends StatefulWidget {
  final int userPosts;
  final int userfriends;
  const ProfileView(
      {super.key, required this.userPosts, required this.userfriends});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffE7E7F2),
      // appBar: AppBar(
      //   title: Text('MyWall',
      //       style: GoogleFonts.poppins(
      //           color: Colors.white, fontWeight: FontWeight.bold)),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       icon: const Icon(
      //         EneftyIcons.arrow_left_2_outline,
      //         color: Colors.black,
      //       )),
      // ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  Timestamp timestamp = userData['lastSeen'];
                  String lastSeenFormatted = formatLastSeen(timestamp);
                  return NewProfilePage(
                    userCoverImage: userData['userCoverImage'],
                    userfriends: widget.userfriends,
                    userPosts: widget.userPosts,
                    userEmail: currentUser.email!,
                    userImage: userData['userImage'],
                    userLastSeen: lastSeenFormatted, //here
                    userortrainer: userData['trainer'], //here
                    userName: userData['username'],
                    userBio: userData['bio'],
                    userweight: userData['weight'],
                    usergender: userData['gender'],
                    userdob: userData['dob'],
                    userlevel: userData['level'],
                    usergoals: userData['goals'],
                    userheight: userData['height'],
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
          ),
        ],
      ),
    );
  }

  String formatLastSeen(Timestamp timestamp) {
    DateTime lastSeen = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastSeen);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return DateFormat('dd MMM yyyy').format(lastSeen);
    }
  }
}
