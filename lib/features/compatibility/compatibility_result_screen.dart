import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/features/compatibility/services/compatibility_service.dart';
import 'package:flutter/material.dart';

class CompatibilityResultScreen extends StatelessWidget {
  final CompatibilityResult result;

  const CompatibilityResultScreen({
    super.key,
    required this.result,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('궁합 결과'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '❤️ 종합 궁합',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              '${result.score}점',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPink,
              ),
            ),
            const SizedBox(height: 30),

            // Analysis Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  const Text(
                    '오운이 분석',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    result.summary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 16),
                  Text(
                    result.advice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ohaeng Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.secondaryBlue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildOhaengRow('나의 오행', result.myOhaeng),
                  const SizedBox(height: 12),
                  _buildOhaengRow('상대방 오행', result.partnerOhaeng),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOhaengRow(String label, String ohaeng) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
        Text(
          ohaeng,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryBlue,
          ),
        ),
      ],
    );
  }
}
