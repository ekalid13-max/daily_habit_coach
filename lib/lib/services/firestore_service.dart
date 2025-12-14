import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGoal(GoalModel goal) async {
    await _firestore.collection('goals').doc(goal.id).set(goal.toMap());
  }

  Stream<List<GoalModel>> streamGoals(String userId) {
    return _firestore
        .collection('goals')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => GoalModel.fromMap(d.id, d.data())).toList());
  }

  Future<void> updateProgress(String goalId, int value) async {
    await _firestore.collection('goals').doc(goalId).update({
      'progressToday': value,
      'lastUpdate': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> upgradePremium(String userId) async {
    await _firestore.collection('users').doc(userId).update({'premium': true});
  }
}
