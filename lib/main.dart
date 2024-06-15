// ignore_for_file: unused_local_variable
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_fit/Music/music_provider.dart';
import 'package:social_fit/firebase_options.dart';
import 'package:social_fit/home/database.dart';
import 'package:social_fit/home/landing/layout.dart';
import 'package:social_fit/home/profile/privacy.dart';
import 'package:social_fit/meal_plan/water/manager/dataManager.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:social_fit/onboard/onboard.dart';
import 'package:social_fit/settings/screens/notifications/notification_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<Database>? database;

List<Session> sessions = [];

Future<void> initDb(Database db) async {
  await db.execute('drop table if exists Schedule');
  await db.execute('drop table if exists Profile');
  await db.execute('drop table if exists GoalExcerciseItem');
  await db.execute('drop table if exists WorkoutGoal');
  await db.execute('drop table if exists ExcerciseGoal');
  await db.execute('drop table if exists StepsGoal');
  await db.execute('drop table if exists Goals');
  await db.execute('drop table if exists Notes');
  await db.execute('drop table if exists Sets');
  await db.execute('drop table if exists ExcerciseInfo');
  await db.execute('drop table if exists Session');

  await db.execute(
      'create table if not exists Schedule(id integer primary key autoincrement not null, bodyParts text, day text)');
  //Goals
  await db.execute(
      'create table if not exists Profile(id integer primary key autoincrement not null, username text, image_path text)');
  await db.execute(
      'create table if not exists Goals(id integer primary key autoincrement not null, title text, date integer)');
  await db.execute(
      'create table if not exists GoalExcerciseItem(id integer primary key autoincrement not null, name text, startingReps integer, startingWeight double, goalReps integer, goalWeight double,bodyPart text, icon_url text)');
  await db.execute(
      'create table if not exists WorkoutGoal(id integer primary key autoincrement not null, number integer, untilDate integer, goalId integer,FOREIGN KEY(goalId) REFERENCES Goals(id) ON DELETE CASCADE )');
  await db.execute(
      'create table if not exists ExcerciseGoal(id integer primary key autoincrement not null, goalId integer,goalExcerciseItemId integer,FOREIGN KEY(goalId) REFERENCES Goals(id) ON DELETE CASCADE , FOREIGN KEY(goalExcerciseItemId) REFERENCES GoalExcerciseItem(id) ON DELETE CASCADE )');
  await db.execute(
      'create table if not exists StepsGoal(id integer primary key autoincrement not null, steps integer, isDaily boolean default false, distance double, duration int, goalId integer,FOREIGN KEY(goalId) REFERENCES Goals(id) ON DELETE CASCADE )');
  //Workout
  await db.execute(
    'create table if not exists Notes(id integer primary key autoincrement not null, note text, excerciseName text, date integer)',
  );
  await db.execute(
      'create table if not exists Sets(id integer primary key autoincrement not null, reps integer, weight double, excerciseInfoId integer, FOREIGN KEY(excerciseInfoId) REFERENCES excerciseInfo(id) ON DELETE CASCADE )');
  await db.execute(
      "CREATE TABLE if not exists ExcerciseInfo(id integer primary key autoincrement not null, excerciseName text, notes text,sessionId integer,FOREIGN KEY(sessionId) REFERENCES Session(id) ON DELETE CASCADE )");
  await db.execute(
      'create table if not exists RunningKM(id integer primary key autoincrement not null, distance double, duration integer, speed double,sessionId integer,FOREIGN KEY(sessionId) REFERENCES OutsideSession(id) ON DELETE CASCADE )');
  await db.execute(
      'create table if not exists OutsideSession(id integer primary key autoincrement not null, date integer)');
  return db.execute(
      'create table if not exists Session(id integer primary key autoincrement not null, date integer, duration integer)');
}

Future<http.Response> fetchInsecure(String url) async {
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  http.Client client = http.Client();
  return await client.get(Uri.parse(url));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), "excercise_info_database.db"),
    onOpen: (db) async {
      await db.execute("PRAGMA foreign_keys=ON");
    },
    onCreate: (db, version) async {
      return await initDb(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 8) {
        return await initDb(db);
      }
    },
    version: 8,
  );
  DataManager.initialize();
  await NotificationService.initializeNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MusicProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Session.sessions().then((data) {
      sessions = data;
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Fit',
        routes: {
          PrivacyPolicy.routeName: (context) => const PrivacyPolicy(),
          LayoutLanding.routeName: (context) => const LayoutLanding()
        },
        theme: ThemeData(
          fontFamily: 'Wotfard',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const OnBoardScreen());
  }
}
