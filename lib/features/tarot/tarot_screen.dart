import 'dart:math';

import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/features/tarot/models/tarot_draw_result.dart';
import 'package:app_project/data/services/tarot_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  static const int _cardsToDisplay = 12;

  final Random _random = Random();
  List<int> _displayCardIds = const [];
  bool _isRevealing = false;

  @override
  void initState() {
    super.initState();
    _generateDisplayCards();
  }

  void _generateDisplayCards() {
    final ids = List<int>.generate(TarotDatabase.majorArcana.length, (index) => index);
    ids.shuffle(_random);
    _displayCardIds = ids.take(_cardsToDisplay).toList();
  }

  Future<void> _onCardSelected(int cardId) async {
    if (_isRevealing) return;

    setState(() {
      _isRevealing = true;
    });

    final isUpright = _random.nextBool();
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    await context.push(
      '/tarot/result',
      extra: TarotDrawResult(cardId: cardId, isUpright: isUpright),
    );

    if (!mounted) return;
    setState(() {
      _isRevealing = false;
      _generateDisplayCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오운이 타로')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '오운이 타로',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '마음을 비우고 카드를 선택해주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _displayCardIds.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: _displayCardIds.length,
                      itemBuilder: (context, index) {
                        final cardId = _displayCardIds[index];
                        return GestureDetector(
                          onTap: _isRevealing ? null : () => _onCardSelected(cardId),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _isRevealing ? 0.6 : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C2C2C),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.style,
                                  color: Colors.grey.shade700,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
