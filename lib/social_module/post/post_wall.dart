// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:social_fit/social_module/home/home_view.dart';
import 'package:social_fit/social_module/utils/reuse_textfield.dart';

class MyPostView extends StatefulWidget {
  final String imageURL;
  final String userName;
  final String userBio;
  const MyPostView(
      {super.key,
      required this.imageURL,
      required this.userName,
      required this.userBio});

  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  final TextEditingController postTxt = TextEditingController();

  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  String currentuserEmail = FirebaseAuth.instance.currentUser!.email.toString();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool pickedImage = true;
  bool takenImage = false;
  int selectedColorIndex = -1;

  static List<List<Color>> gradients = [
    [const Color(0xFFD76D77), const Color(0xFFA2348C)],
    [const Color(0xFF80D0C7), const Color(0xFF13547A)],
    [const Color(0xFFEAECC6), const Color(0xFF3E6B60)],
    [const Color(0xFF78D5E3), const Color(0xFF415A77)],
    [const Color(0xFFC7F0BD), const Color(0xFF3E514D)],
    [const Color(0xFFDAA9A2), const Color(0xFF9A1750)],
    [const Color(0xFFBED6C7), const Color(0xFF3E3D40)],
    [const Color(0xFFE1DDDB), const Color(0xFF3E3D40)],
  ];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        pickedImage = false;
        takenImage = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.imageURL);
  }

  @override
  Widget build(BuildContext context) {
    final double buttonwidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: const Color(0xff000221),
        title: const Text('Add Post',
            style: TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Post',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 38)),
                      // const SizedBox(
                      //     height: 40, width: 30, child: Icon(Icons.))
                    ],
                  ),
                  Text('Share the post with others',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ReuseTextField(
                      emailLabel: 'Post....',
                      emailLogin: postTxt,
                      isObscure: false,
                      prefixIcon: const Icon(EneftyIcons.additem_bold),
                      suffixIcon: false,
                      onSuffixIconChange: false,
                    ),
                  ),

                  //Upload Photo or Video

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('You can add Photo/Video',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: takenImage
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: takenImage,
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: _imageFile != null
                                        ? Image.file(
                                            _imageFile!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : null,
                                  ),
                                ),
                                if (_imageFile != null)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _imageFile = null;
                                          takenImage = false;
                                          pickedImage = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          Icons.cancel,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: pickedImage,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                                color: const Color(0xffE7E7F2),
                              ),
                              child: IconButton(
                                  onPressed: () =>
                                      _pickImage(ImageSource.camera),
                                  icon: const Icon(Icons.camera)),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Visibility(
                            visible: pickedImage,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                                color: const Color(0xffE7E7F2),
                              ),
                              child: IconButton(
                                  onPressed: () =>
                                      _pickImage(ImageSource.gallery),
                                  icon: const Icon(Icons.image)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // background Color

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: Text('You can add Background Color',
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.bold, fontSize: 18)),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Row(
                  //     children: [
                  //       Row(
                  //         children: List.generate(
                  //             8, (index) => colorContainer(index)),
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: RoundedLoadingButton(
                      width: buttonwidth * 0.8,
                      color: const Color(0xff00C1AA),
                      controller: controller,
                      animateOnTap: true,
                      errorColor: Colors.red,
                      failedIcon: Icons.error,
                      onPressed: () async {
                        controller.start();
                        if (postTxt.text.isNotEmpty || _imageFile != null) {
                          try {
                            String imageUrl = '';
                            if (_imageFile != null) {
                              Reference ref = FirebaseStorage.instance
                                  .ref()
                                  .child('images/${DateTime.now().toString()}');
                              await ref.putFile(_imageFile!);
                              imageUrl = await ref.getDownloadURL();
                            }

                            Color selectedColor = Colors.white;

                            if (selectedColorIndex != -1) {
                              selectedColor = gradients[selectedColorIndex][0];
                            }

                            await FirebaseFirestore.instance
                                .collection('User Posts')
                                .add({
                              'UserName': widget.userName, //hardcoded
                              'UserImage': widget
                                  .imageURL, // Picking up from register screen
                              'UserEmail': currentuserEmail,
                              'Bio': widget.userBio,
                              'Message': postTxt.text,
                              'TimeStamp': Timestamp.now(),
                              'Likes': [],

                              'imageUrl': imageUrl, // Use the retrieved URL
                              'backgroundColor': selectedColor.value,
                            });

                            controller.stop();
                            Get.snackbar('Post', 'Successfully Posted',
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                ),
                                backgroundColor: Colors.green,
                                borderRadius: 12,
                                snackPosition: SnackPosition.BOTTOM);

                            setState(() {
                              postTxt.clear();
                              _imageFile = null; // Clear the image file
                              pickedImage = true; // Reset image selection
                              takenImage = false;
                            });

                            Get.to(() => const HomeView());
                          } catch (error) {
                            controller.stop();
                            Get.snackbar('Post', 'Failed to post: $error',
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                ),
                                backgroundColor: Colors.red,
                                borderRadius: 12,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        } else {
                          controller.stop();
                          Get.snackbar(
                            'Empty Post',
                            'Empty Post Can\'t be uploaded',
                            margin: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            backgroundColor: Colors.red,
                            borderRadius: 12,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text(
                        'Post',
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget colorContainer(int index) {
    Color color = gradients[index][0];
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selectedColorIndex == index
                  ? Colors.white
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: selectedColorIndex == index
              ? const Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 20,
                )
              : null,
        ),
      ),
    );
  }
}
