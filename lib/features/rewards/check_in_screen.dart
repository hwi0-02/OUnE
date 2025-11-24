import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:app_project/features/rewards/check_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('출석 체크'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('로그인이 필요합니다.', style: TextStyle(color: Colors.white)));
          }

          final walletAsync = ref.watch(walletProvider(user.id));
          final streakAsync = ref.watch(currentStreakProvider(user.id));
          final historyAsync = ref.watch(checkInHistoryProvider(user.id));
          final todayCheckInAsync = ref.watch(todayCheckInProvider(user.id));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Wallet Balance
                walletAsync.when(
                  data: (wallet) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.pointGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.pointGold.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍬', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          '보유 솜사탕: ${wallet.balance}개',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.pointGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 20),

                // Character Message
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPink.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.face, color: AppTheme.primaryPink),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '매일 오는 거 기특해!\\n솜사탕 받아가! ♡',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Calendar
                historyAsync.when(
                  data: (history) => _buildCalendar(context, history),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('에러: $e', style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 30),

                // Streak Info
                streakAsync.when(
                  data: (streak) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.pointGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.pointGold.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          '연속 출석: $streak일 🔥',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 20),

                // Reward Info
                _buildRewardInfo(),
                const SizedBox(height: 30),

                // Check-in Button
                todayCheckInAsync.when(
                  data: (todayCheckIn) {
                    final isCheckedToday = todayCheckIn != null;
                    return _buildCheckInButton(
                      context,
                      ref,
                      user.id,
                      isCheckedToday,
                      todayCheckIn?.rewardAmount,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('에러가 발생했습니다.', style: TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, List checkInHistory) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Convert history to Set of checked days
    final checkedDays = checkInHistory
        .map((checkIn) => checkIn.checkInDate.day)
        .toSet();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('yyyy년 MM월').format(now),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isChecked = checkedDays.contains(day);
              final isToday = day == now.day;

              return Container(
                decoration: BoxDecoration(
                  color: isChecked
                      ? AppTheme.primaryPink
                      : (isToday ? AppTheme.primaryPink.withOpacity(0.2) : const Color(0xFF2C2C2C)),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isChecked
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '$day',
                          style: TextStyle(
                            color: isToday ? AppTheme.primaryPink : Colors.white70,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRewardInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 출석 보상',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('• 1일: 솜사탕 1개', style: TextStyle(color: Colors.white70)),
            ],
          ),
          Row(
            children: [
              Text('• 3일 연속: 솜사탕 3개', style: TextStyle(color: Colors.white70)),
            ],
          ),
          Row(
            children: [
              Text('• 7일 연속: 솜사탕 10개 🎉', style: TextStyle(color: Colors.white70)),
            ],
          ),
          Row(
            children: [
              Text('• 30일 연속: 솜사탕 30개 + 특별 배경화면 🎁', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(
    BuildContext context,
    WidgetRef ref,
    String userId,
    bool isCheckedToday,
    int? rewardAmount,
  ) {
    final checkInNotifier = ref.watch(checkInNotifierProvider);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isCheckedToday
            ? null
            : () async {
                await ref.read(checkInNotifierProvider.notifier).performCheckIn(userId);
                
                if (context.mounted) {
                  final result = ref.read(checkInNotifierProvider);
                  result.whenData((checkIn) {
                    if (checkIn != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('출석 완료! 솜사탕 ${checkIn.rewardAmount}개를 받았어요 🎉'),
                          backgroundColor: AppTheme.primaryPink,
                        ),
                      );
                    }
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isCheckedToday ? Colors.grey : AppTheme.primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: checkInNotifier.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                isCheckedToday
                    ? '오늘 출석 완료 (+${rewardAmount ?? 0}개)'
                    : '출석하고 솜사탕 받기',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
