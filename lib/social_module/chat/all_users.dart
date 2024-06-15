// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:social_fit/social_module/chat/chat_page.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: const Color(0xff000221),
        title: const Text('Social Fit',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut().then((value) {
        //           Get.off(() => const LoginView());
        //         });
        //       },
        //       icon: const Icon(
        //         EneftyIcons.logout_outline,
        //         color: Colors.black,
        //       ))
        // ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load Users'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      Timestamp lastSeenTimestamp = data['lastSeen'];
      DateTime lastSeenDateTime = lastSeenTimestamp.toDate();
      Duration difference = DateTime.now().difference(lastSeenDateTime);
      String lastSeenText = 'Last seen: ${difference.inMinutes} minutes ago';

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: const Color.fromARGB(255, 213, 185, 185),
          child: ListTile(
            trailing: const Icon(EneftyIcons.message_2_outline),
            leading: CircleAvatar(
              radius: 20, // adjust the radius as needed
              backgroundImage: NetworkImage(data['userImage']),
            ),
            title: Text(data['email']),
            subtitle: Text(lastSeenText),
            onTap: () {
              Get.to(() => ChatPage(
                    receiveruseruid: data['uid'],
                    receiveruserEmail: data['email'],
                    userName: data['username'],
                  ));
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
