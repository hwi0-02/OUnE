import 'dart:math';

import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/services/tarot_database.dart';
import 'package:app_project/features/tarot/models/tarot_draw_result.dart';
import 'package:flutter/material.dart';

class TarotResultScreen extends StatelessWidget {
  const TarotResultScreen({super.key, this.drawResult});

  final TarotDrawResult? drawResult;

  @override
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final int cardId = drawResult?.cardId ?? random.nextInt(TarotDatabase.majorArcana.length);
    final card = TarotDatabase.majorArcana[cardId];
    final bool isUpright = drawResult?.isUpright ?? random.nextBool();

    return Scaffold(
      appBar: AppBar(
        title: const Text('타로 결과'),
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
            Text(
              card.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              '${card.nameKr} ${isUpright ? "(정방향)" : "(역방향)"}',
              style: TextStyle(
                fontSize: 16,
                color: isUpright ? AppTheme.primaryPink : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // Card Image Placeholder
            Transform.rotate(
              angle: isUpright ? 0 : 3.14159, // π radians = 180 degrees
              child: Container(
                width: 200,
                height: 340,
                decoration: BoxDecoration(
                  color: isUpright 
                      ? AppTheme.primaryPink.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUpright ? AppTheme.primaryPink : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getCardIcon(card.id),
                        size: 80,
                        color: isUpright ? AppTheme.primaryPink : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        card.nameKr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isUpright ? AppTheme.primaryPink : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Keywords
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                isUpright ? card.uprightKeywords : card.reversedKeywords,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            
            // Interpretation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  const Text(
                    '오운이가 해석해줄게!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isUpright ? card.uprightMessage : card.reversedMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCardIcon(int id) {
    // Map card IDs to appropriate icons
    switch (id) {
      case 0: return Icons.accessibility_new; // Fool
      case 1: return Icons.auto_awesome; // Magician
      case 2: return Icons.nights_stay; // High Priestess
      case 3: return Icons.favorite; // Empress
      case 4: return Icons.shield; // Emperor
      case 5: return Icons.menu_book; // Hierophant
      case 6: return Icons.favorite_border; // Lovers
      case 7: return Icons.directions_car; // Chariot
      case 8: return Icons.fitness_center; // Strength
      case 9: return Icons.lightbulb_outline; // Hermit
      case 10: return Icons.refresh; // Wheel of Fortune
      case 11: return Icons.balance; // Justice
      case 12: return Icons.swap_vert; // Hanged Man
      case 13: return Icons.refresh; // Death (transformation)
      case 14: return Icons.waves; // Temperance
      case 15: return Icons.warning; // Devil
      case 16: return Icons.flash_on; // Tower
      case 17: return Icons.star; // Star
      case 18: return Icons.nightlight_round; // Moon
      case 19: return Icons.wb_sunny; // Sun
      case 20: return Icons.campaign; // Judgement
      case 21: return Icons.public; // World
      default: return Icons.help_outline;
    }
  }
}
