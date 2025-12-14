import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/goal_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/ai_service.dart';
import '../create_goal/create_goal_screen.dart';
import '../premium/premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _db = FirestoreService();
  String _aiMessage = "جاري التحميل...";

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  void _loadMessage() async {
    final msg = await AiService.generateDailyMessage("متحمس", "شرب الماء");
    if (mounted) setState(() => _aiMessage = msg);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('هدفك اليومي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const PremiumScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<AuthService>(context, listen: false)
                .signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<GoalModel>>(
        stream: _db.streamGoals(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final goals = snapshot.data!;
          if (goals.isEmpty) {
            return const Center(child: Text('لم تنشئ هدفًا بعد'));
          }
          final goal = goals.first;
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  title: Text(goal.title),
                  subtitle: Text("التذكير: ${goal.reminderTime} | المستوى: ${goal.level}"),
                  trailing: goal.progressToday == 1
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () async {
                            await _db.updateProgress(goal.id, 1);
                            _loadMessage();
                          },
                          child: const Text('أنجزت اليوم'),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_aiMessage,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CreateGoalScreen())),
      ),
    );
  }
}
