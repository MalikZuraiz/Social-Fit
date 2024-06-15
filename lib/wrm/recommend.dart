// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'excercise_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final String data;

  const ExerciseScreen({super.key, required this.data});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  List<dynamic> exercises = [];

  @override
  void initState() {
    super.initState();
    exercises = jsonDecode(widget.data) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: const Color(0xff000221),
        title: const Text('Recommended Exercises',
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
      ),
      backgroundColor: Colors.grey[100],
      body: exercises.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 0), // Add padding here
              child: Center(
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                      height: 420.0, // Adjust height if needed
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.70,
                      enlargeCenterPage: true,
                      pageSnapping: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: exercises.map((exercise) {
                    String imageUrl = exercise['Exercise_Image'] ?? '';
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailsScreen(
                                  exerciseDetails: exercise,
                                ),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: _current == exercises.indexOf(exercise)
                                    ? Border.all(
                                        color: Colors.blue.shade500, width: 3)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 5))
                                ]),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Hero(
                                    tag:
                                        'exercise_${exercise['Exercise_Name']}', // Unique tag for each exercise
                                    child: Container(
                                      height: 320,
                                      clipBehavior: Clip.hardEdge,
                                      margin: const EdgeInsets.only(top: 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(imageUrl,
                                              fit: BoxFit.cover)
                                          : const Icon(
                                              Icons.image,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    exercise['Exercise_Name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Muscle: ${exercise['Muscle_Group']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Rating: ${exercise['Rating']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
