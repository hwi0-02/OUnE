import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/models/user_model.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:app_project/features/calendar/models/daily_fortune.dart';
import 'package:app_project/features/calendar/services/fortune_calendar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DailyFortune? _selectedDayFortune;
  final FortuneCalendarService _fortuneService = FortuneCalendarService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadSelectedDayFortune();
  }

  void _loadSelectedDayFortune() {
    final userState = ref.read(userProvider);
    userState.whenData((userData) {
      if (userData != null && _selectedDay != null) {
        setState(() {
          _selectedDayFortune = _fortuneService.calculateDailyFortune(
            userBirthDate: userData.birthDate,
            targetDate: _selectedDay!,
          );
        });
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('운세 캘린더'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: userState.when(
        data: (userData) {
          if (userData == null) {
            return const Center(child: Text('사용자 정보를 불러올 수 없습니다.', style: TextStyle(color: Colors.white)));
          }
          return _buildCalendarView(userData);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류: $error', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildCalendarView(UserModel userData) {
    return Column(
      children: [
        // 캘린더
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedDayFortune = _fortuneService.calculateDailyFortune(
                  userBirthDate: userData.birthDate,
                  targetDate: selectedDay,
                );
              });
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.redAccent),
              outsideTextStyle: TextStyle(color: Colors.grey.shade700),
              selectedDecoration: const BoxDecoration(
                color: AppTheme.primaryPink,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.secondaryBlue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                // 길일 표시
                final fortune = _fortuneService.calculateDailyFortune(
                  userBirthDate: userData.birthDate,
                  targetDate: day,
                );
                
                if (fortune.isLuckyDay) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),

        // 선택한 날짜의 운세
        Expanded(
          child: _selectedDayFortune == null
              ? const Center(child: Text('날짜를 선택해주세요', style: TextStyle(color: Colors.grey)))
              : _buildFortuneCard(_selectedDayFortune!),
        ),
      ],
    );
  }

  Widget _buildFortuneCard(DailyFortune fortune) {
    final dateStr = DateFormat('yyyy년 M월 d일 (E)', 'ko').format(fortune.date);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 및 총운
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPink.withOpacity(0.2),
                  AppTheme.secondaryBlue.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${fortune.dayType}  ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: fortune.isLuckyDay ? Colors.orange : Colors.grey,
                      ),
                    ),
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < fortune.stars ? Icons.star : Icons.star_border,
                        color: AppTheme.pointGold,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${fortune.totalScore}점',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  fortune.summary,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 세부 운세
          _buildDetailScoreCard('💕 연애운', fortune.loveScore),
          const SizedBox(height: 8),
          _buildDetailScoreCard('💰 재물운', fortune.moneyScore),
          const SizedBox(height: 8),
          _buildDetailScoreCard('💼 직장운', fortune.workScore),
          const SizedBox(height: 8),
          _buildDetailScoreCard('💪 건강운', fortune.healthScore),
          const SizedBox(height: 16),

          // 럭키 아이템
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🍀 오늘의 럭키 아이템',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLuckyItem('🌈 럭키 컬러', fortune.luckyColor),
                    _buildLuckyItem('🎵 럭키 넘버', '${fortune.luckyNumber}'),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: _buildLuckyItem('⏰ 럭키 타임', fortune.luckyTime),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailScoreCard(String title, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          const Spacer(),
          ...List.generate(
            5,
            (index) => Icon(
              index < ((score / 20).ceil()).clamp(1, 5)
                  ? Icons.star
                  : Icons.star_border,
              color: AppTheme.pointGold,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$score점',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPink,
          ),
        ),
      ],
    );
  }
}
