// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_fit/meal_plan/water/models/CupModel.dart';
import 'package:social_fit/meal_plan/water/models/UserState.dart';


class DataManager {
  static const String _dataSavedKey = "_userPreferences";

  static DataManager? instance;

  static void initialize() {
    DataManager.instance = DataManager();
  }

  late UserState userData;

  int get userCurrentProgress => userData.userCurrentProgress;

  DateTime get userCurrentProgressLastDate =>
      userData.userCurrentProgressLastDate;

  int get userCurrentGoal => userData.userCurrentGoal;

  bool get enableNotifications => userData.enableNotifications;

  List<CupModel> cupsAvailable = [
    CupModel(100),
    CupModel(150),
    CupModel(200),
    CupModel(300),
    CupModel(400),
    CupModel(500),
    CupModel(750),
    CupModel(800),
    CupModel(900),
    CupModel(920),
    CupModel(1000),
  ];

  DataManager() {
    userData = UserState(userCurrentProgressLastDate: DateTime.now());
    _readUserPreferences();

    final today = DateTime.now();

    if (userCurrentProgressLastDate.day != today.day ||
        userCurrentProgressLastDate.month != today.month ||
        userCurrentProgressLastDate.year != today.year) {
      setUserData(progress: 0);
    }
  }

  Future<void> _readUserPreferences() async {
    try {
      userData = await _loadData();
      final today = DateTime.now();
      if (userCurrentProgressLastDate.day != today.day ||
          userCurrentProgressLastDate.month != today.month ||
          userCurrentProgressLastDate.year != today.year) {
        await setUserData(progress: 0);
      }
        } catch (e) {
      userData = UserState(userCurrentProgressLastDate: DateTime.now());
    }
  }

  Future<bool> setUserData(
      {final int? goal,
      final int? progress,
      final bool? bNotifications}) async {
    Completer<bool> completer = Completer<bool>();

    if (goal != null && goal > 0) {
      userData.userCurrentGoal = goal;
    }
    if (progress != null && progress >= 0) {
      userData.userCurrentProgress = progress;
      userData.userCurrentProgressLastDate = DateTime.now();
    }

    if (bNotifications != null) {
      userData.enableNotifications = bNotifications;
    }

    try {
      await _saveData(userData);
      completer.complete(true);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<void> _saveData(final UserState finalData) async {
    Completer<void> completer = Completer<void>();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(_dataSavedKey, jsonEncode(finalData.toJson()));
      completer.complete();
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<UserState> _loadData() async {
    Completer<UserState> completer = Completer<UserState>();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final dataString = prefs.getString(_dataSavedKey);
      final data = UserState.fromJson(jsonDecode(dataString!));

      completer.complete(data);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}
