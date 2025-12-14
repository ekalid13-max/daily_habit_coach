import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    final db = FirestoreService();
    return Scaffold(
      appBar: AppBar(title: const Text('النسخة المميزة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المميزات المدفوعة:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• أكثر من هدف يومي'),
            const Text('• رسائل فلسفية طويلة'),
            const Text('• مزامنة كاملة عبر السحابة'),
            const Text('• اختيار أصوات الذكاء الاصطناعي (قريبًا)'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await db.upgradePremium(user.uid);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم الترقية!')));
                },
                child: const Text('ترقية الحساب'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
