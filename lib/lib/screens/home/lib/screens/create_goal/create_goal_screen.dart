import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/goal_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  TimeOfDay? _time;
  String _level = 'medium';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    final db = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء عادة جديدة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'اسم العادة'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_time == null
                    ? 'اختر وقت التذكير'
                    : 'التذكير: ${_time!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _time = picked);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _level,
                items: const [
                  DropdownMenuItem(value: 'calm', child: Text('هادئ')),
                  DropdownMenuItem(value: 'medium', child: Text('متوسط')),
                  DropdownMenuItem(value: 'strong', child: Text('قوي')),
                ],
                onChanged: (v) => setState(() => _level = v!),
                decoration: const InputDecoration(labelText: 'مستوى التحفيز'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _time != null) {
                    final goal = GoalModel(
                      id: FirebaseFirestore.instance.collection('goals').doc().id,
                      userId: user.uid,
                      title: _title.text.trim(),
                      reminderTime: _time!.format(context),
                      level: _level,
                      lastUpdate: DateTime.now(),
                    );
                    await db.createGoal(goal);
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
