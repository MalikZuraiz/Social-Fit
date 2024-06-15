// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:social_fit/meal_plan/meal/db_model.dart';
import 'package:social_fit/meal_plan/meal/food_charts.dart';

class FoodScreen extends StatefulWidget {
  final String mealTime;
  final List<Map<String, dynamic>> foods;

  const FoodScreen({super.key, required this.mealTime, required this.foods});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<String> selectedFoods = [];
  List<int> selectedFoodsCal = [];
  List<int> selectedFoodsPro = [];
  late List<Map<String, dynamic>> filteredFoods;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFoods = widget.foods;
    searchController.addListener(() {
      filterFoods();
    });
  }

  void filterFoods() {
    setState(() {
      filteredFoods = widget.foods
          .where((food) => food['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(widget.mealTime,
            style: const TextStyle(
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xff000221))),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedFoods.clear();
                selectedFoodsCal.clear();
                selectedFoodsPro.clear();
              });
            },
            icon: const Icon(EneftyIcons.refresh_outline),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => ChartsPage(
                    mealTime: widget.mealTime,
                  ));
            },
            icon: const Icon(EneftyIcons.chart_2_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Foods',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                var food = filteredFoods[index];
                return InkWell(
                  onLongPress: () {
                    setState(() {
                      if (selectedFoods.contains(food["name"])) {
                        selectedFoods.remove(food["name"]);
                        selectedFoodsCal.remove(food['calories']);
                        selectedFoodsPro.remove(food['proteins']);
                      } else {
                        selectedFoods.add(food["name"]);
                        selectedFoodsCal.add(food['calories']);
                        selectedFoodsPro.add(food['proteins']);
                      }
                    });
                  },
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(food["name"]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(food["serving_size"]),
                            Row(
                              children: [
                                Text("Proteins: ${food["proteins"]}g"),
                                const SizedBox(width: 10),
                                Text("Calories: ${food["calories"]}"),
                              ],
                            ),
                          ],
                        ),
                        trailing: selectedFoods.contains(food["name"])
                            ? const Icon(Icons.check_box)
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedFoods.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                final dbHelper = DBHelper();
                // Get the current date
                String currentDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());

                // Clear existing data
                for (var i = 0; i < selectedFoods.length; i++) {
                  await dbHelper.insertMealFood(
                    currentDate,
                    selectedFoodsPro[i],
                    selectedFoodsCal[i],
                  );
                }

                setState(() {
                  selectedFoods.clear();
                  selectedFoodsCal.clear();
                  selectedFoodsPro.clear();
                });

                // Print the contents of the database
                final mealFoods = await dbHelper.getMealFoods();
                print('Stored foods:');
                for (var food in mealFoods) {
                  print(
                      'Proteins: ${food['proteins']}, Calories: ${food['calories']}');
                }

                Get.snackbar(
                  widget.mealTime,
                  'Food is Added Successfully',
                  margin: const EdgeInsets.only(
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  backgroundColor: Colors.green,
                  borderRadius: 12,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              label: const Text('Save'),
              icon: const Icon(Icons.save),
            )
          : null,
    );
  }
}
