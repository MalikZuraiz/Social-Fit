import 'package:social_fit/main.dart';

class OutsideSession {
  final DateTime date;
  final int? id;
  List<RunningKM> runningKM = [];
  OutsideSession({required this.date, this.id});

  factory OutsideSession.fromJson(Map<String, dynamic> data) {
    return OutsideSession(
        date: DateTime.fromMillisecondsSinceEpoch(data['date']),
        id: data['id']);
  }

  Future<void> saveSession() async {
    final db = await database;
    if (db == null) return;
    if (id == null) {
      int id = await db.insert('OutsideSession', toJson());
      for (int i = 0; i < runningKM.length; i++) {
        await db.insert('RunningKM', runningKM[i].toJson(id));
      }
      return;
    }
    await db
        .update('OutsideSession', toJson(), where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> toJson() {
    return {'date': date.millisecondsSinceEpoch};
  }

  static Future<List<OutsideSession>> outsideSessions() async {
    final db = await database;
    if (db == null) return [];
    List<OutsideSession> sessions = [];
    final List<Map<String, dynamic>> maps = await db.query('OutsideSession');
    for (int i = 0; i < maps.length; i++) {
      List<RunningKM> km = [];
      OutsideSession session = OutsideSession.fromJson(maps[i]);
      List<Map<String, dynamic>> runningKMs = await db.query('RunningKM',
          where: 'sessionId = ?', whereArgs: [maps[i]['id']]);
      for (int j = 0; j < runningKMs.length; j++) {
        km.add(RunningKM.fromJson(runningKMs[j]));
      }
      session.runningKM = km;
      sessions.add(session);
    }
    return sessions;
  }
}

class RunningKM {
  final double distance;
  final int duration;
  final double speed;
  final int? id;
  RunningKM(
      {required this.distance,
      required this.duration,
      required this.speed,
      this.id});

  Map<String, dynamic> toJson(int sessionId) {
    return {
      'distance': distance,
      'duration': duration,
      'speed': speed,
      'sessionId': sessionId,
    };
  }

  factory RunningKM.fromJson(Map<String, dynamic> data) {
    return RunningKM(
        distance: data['distance'],
        duration: data['duration'],
        speed: data['speed'],
        id: data['id']);
  }
}
