import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:app_project/features/compatibility/services/compatibility_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CompatibilityInputScreen extends ConsumerStatefulWidget {
  const CompatibilityInputScreen({super.key});

  @override
  ConsumerState<CompatibilityInputScreen> createState() => _CompatibilityInputScreenState();
}

class _CompatibilityInputScreenState extends ConsumerState<CompatibilityInputScreen> {
  DateTime? _partnerDate;
  String? _partnerGender;
  final CompatibilityService _service = CompatibilityService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryPink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _partnerDate) {
      setState(() {
        _partnerDate = picked;
      });
    }
  }

  void _calculateCompatibility() {
    final userState = ref.read(userProvider);
    
    userState.when(
      data: (user) {
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('사용자 정보를 불러올 수 없습니다.')),
          );
          return;
        }

        if (_partnerDate == null || _partnerGender == null) return;

        final result = _service.analyzeCompatibility(
          birthDate1: user.birthDate,
          birthDate2: _partnerDate!,
          name1: user.nickname ?? '나',
          name2: '상대방', // 상대방 이름 입력 필드가 없으므로 기본값 사용
        );

        context.push('/compatibility/result', extra: result);
      },
      loading: () {},
      error: (err, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $err')),
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('궁합 보기'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('로그인이 필요합니다.', style: TextStyle(color: Colors.white)));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    '궁금한 사람과의 궁합을\n알아볼까? 두근두근! 💕',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                
                // My Info Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('나의 정보', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '${user.nickname} (${DateFormat('yyyy.MM.dd').format(user.birthDate)})',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const Text('상대방 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                
                // Date Input
                const Text('생년월일', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                      fillColor: const Color(0xFF1E1E1E),
                      filled: true,
                    ),
                    child: Text(
                      _partnerDate != null
                          ? DateFormat('yyyy년 MM월 dd일').format(_partnerDate!)
                          : '날짜를 선택해주세요',
                      style: TextStyle(color: _partnerDate != null ? Colors.white : Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Gender Input
                const Text('성별', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderButton('여성', 'female'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildGenderButton('남성', 'male'),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Spacing before button

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_partnerDate != null && _partnerGender != null)
                        ? _calculateCompatibility
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '궁합 보기 (솜사탕 300개)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _partnerGender == value;
    return OutlinedButton(
      onPressed: () => setState(() => _partnerGender = value),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryPink.withOpacity(0.2) : const Color(0xFF1E1E1E),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryPink : Colors.white.withOpacity(0.1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryPink : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
