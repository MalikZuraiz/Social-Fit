import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_fit/social_module/widgets/profile_post_card.dart';

class UserPostsTabView extends StatelessWidget {
  const UserPostsTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const tabBarHeight = 48.0; // Assuming the TabBar height is 48.0
    final screenHeight = MediaQuery.of(context).size.height;
    final idealHeight = screenHeight - tabBarHeight;

    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Tagged'),
            ],
          ),
          SizedBox(
            height: idealHeight,
            child: TabBarView(
              children: [
                _postsGridView(context),
                _postsImagesGridView(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _postsGridView(BuildContext context) {
    return StreamBuilder(
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
    );
  }

  Widget _postsImagesGridView(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('User Posts')
          .orderBy('TimeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 pictures per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];
              return Image.network(
                post['imageUrl'],
                fit: BoxFit.cover,
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
    );
  }
}
