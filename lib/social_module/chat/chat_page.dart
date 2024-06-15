import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:social_fit/social_module/chat/bubble_chat.dart';
import 'package:social_fit/social_module/chat/chatting_services.dart';
import 'package:social_fit/social_module/utils/reuse_textfield.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruseruid;
  final String userName;
  const ChatPage(
      {super.key,
      required this.receiveruserEmail,
      required this.receiveruseruid,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiveruseruid, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
       appBar: AppBar(
        // backgroundColor: const Color(0xff000221),
        title:  Text(widget.userName,
            style: const TextStyle(
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
        //           Get.to(() => const LoginView());
        //         });
        //       },
        //       icon: const Icon(
        //         EneftyIcons.logout_outline,
        //         color: Colors.black,
        //       ))
        // ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatList()),
          _buildMessagenput(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiveruseruid, _firebaseAuth.currentUser!.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages available.'),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessagenItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessagenItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case where data is null, you can return an empty container or handle it as appropriate
      return Container();
    }

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var crossAxisAlignment =
        (data['senderID'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;

    var mainAxisAlignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(data['senderEmail'] ??
                ''), // Use ?? to provide a default value if senderEmail is null
            ChatBubble(message: data['message'])
            // Use ?? to provide a default value if messsage is null
          ],
        ),
      ),
    );
  }

  Widget _buildMessagenput() {
    return Row(
      children: [
        Expanded(
            child: ReuseTextField(
                emailLogin: _messageController,
                prefixIcon: const Icon(EneftyIcons.message_2_outline),
                emailLabel: 'Send Message',
                isObscure: false)),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(EneftyIcons.send_2_outline)),
      ],
    );
  }
}
