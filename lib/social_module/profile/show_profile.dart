// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:social_fit/social_module/profile/profile_wall.dart';
import 'package:social_fit/social_module/utils/reuse_textfield.dart';

class ShowProfile extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userBio;
  final String userImage;
  final String userLastSeen;
  final bool userortrainer;

  const ShowProfile({
    super.key,
    required this.userEmail,
    required this.userName,
    required this.userBio,
    required this.userImage,
    required this.userLastSeen,
    required this.userortrainer,
  });

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(EneftyIcons.arrow_left_2_outline),
          ),
          title: Text(
            widget.userName,
            style: GoogleFonts.poppins(),
          ),
        ),
        body: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    image: DecorationImage(
                      image: NetworkImage(widget.userImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        // Handle change cover image
                      },
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(widget.userImage),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                widget.userName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 8, bottom: 4),
              child: Text(
                'My Details',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
            Card(
              elevation: 2,
              color: Colors.grey[200], // Add a slight shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                side: BorderSide(color: Colors.grey[300]!), // Add a border
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(EneftyIcons.bill_outline,
                            size: 20, color: Colors.grey),
                        const SizedBox(
                            width: 8), // Add space between the icon and text
                        Text(
                          widget.userBio,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            8), // Add some space between the bio and other information
                    Row(
                      children: [
                        const Icon(EneftyIcons.message_add_outline,
                            size: 20, color: Colors.grey),
                        const SizedBox(
                            width: 8), // Add space between the icon and text
                        Text(
                          widget.userEmail,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            8), // Add some space between email and last seen
                    Row(
                      children: [
                        const Icon(EneftyIcons.timer_outline,
                            size: 20, color: Colors.grey),
                        const SizedBox(
                            width: 8), // Add space between the icon and text
                        Text(
                          widget.userLastSeen,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            8), // Add some space between last seen and user type
                    Row(
                      children: [
                        const Icon(EneftyIcons.user_outline,
                            size: 20, color: Colors.grey),
                        const SizedBox(
                            width: 8), // Add space between the icon and text
                        Text(
                          widget.userortrainer ? 'Trainer' : 'User',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 8, bottom: 4),
              child: Text(
                'My Posts',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        final postTime =
                            (post['TimeStamp'] as Timestamp).toDate();
                        final formattedTime = DateFormat.jm().format(postTime);
                        return PostDesignforProfile(
                            postID: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                            imageofUser: post['UserImage'],
                            userBio: post['Bio'],
                            backgroundColor: post['backgroundColor'],
                            postImage: post['imageUrl'], //empty value
                            timeofPost: formattedTime, //hardcore value
                            postText: post['Message'],
                            userEmail: post['UserEmail'],
                            userName: post['UserName']);
                      });
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
          ],
        ),
      ),
    );
  }

  // Function to show the alert box with TextField
  Future<void> _showChangeNameDialog(
    BuildContext context,
    String sectionName,
    String field,
  ) async {
    TextEditingController newNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change $sectionName'),
          content: ReuseTextField(
            emailLogin: newNameController,
            prefixIcon: const Icon(Icons.fiber_new_rounded),
            emailLabel: 'Enter New $sectionName',
            isObscure: false,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog on Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = newNameController.text;
                if (newName.trim().isNotEmpty) {
                  // Perform any validation or processing as needed
                  // ...

                  // Close the dialog and perform the change
                  Navigator.pop(context, newName);

                  // Update the username in Firestore
                  await usersCollection.doc(currentUser.email).update({
                    field: newName,
                  });
                } else {
                  // Show a snackbar or handle the case where the entered text is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid name.'),
                    ),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
