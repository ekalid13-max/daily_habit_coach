import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String userId;
  final String title;
  final String reminderTime; // "HH:mm"
  final String level; // calm / medium / strong
  int progressToday;
  DateTime lastUpdate;

  GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.reminderTime,
    required this.level,
    this.progressToday = 0,
    required this.lastUpdate,
  });

  factory GoalModel.fromMap(String id, Map<String, dynamic> data) =>
      GoalModel(
        id: id,
        userId: data['userId'],
        title: data['title'],
        reminderTime: data['reminderTime'],
        level: data['level'],
        progressToday: data['progressToday'],
        lastUpdate: (data['lastUpdate'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'title': title,
        'reminderTime': reminderTime,
        'level': level,
        'progressToday': progressToday,
        'lastUpdate': Timestamp.fromDate(lastUpdate),
      };
}
