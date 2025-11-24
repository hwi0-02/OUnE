import 'package:app_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 더보기 메뉴 화면
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더보기'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
        children: [
          _buildMenuCard(
            context,
            icon: Icons.book,
            title: '정통 사주',
            subtitle: '평생 총운 분석',
            color: Colors.deepPurpleAccent,
            onTap: () => context.push('/saju-analysis'),
          ),
          _buildMenuCard(
            context,
            icon: Icons.favorite,
            title: '궁합 보기',
            subtitle: '우리 인연 점수',
            color: AppTheme.primaryPink,
            onTap: () => context.push('/compatibility'),
          ),
          _buildMenuCard(
            context,
            icon: Icons.calendar_today,
            title: '신년 운세',
            subtitle: '2025년 미리보기',
            color: Colors.blue,
            onTap: () => context.push('/yearly-fortune'),
          ),
          _buildMenuCard(
            context,
            icon: Icons.badge,
            title: '작명소',
            subtitle: '내 이름 점수는?',
            color: Colors.amber,
            onTap: () => context.push('/name-analysis'),
          ),
          _buildMenuCard(
            context,
            icon: Icons.nightlight_round,
            title: '꿈해몽',
            subtitle: '꿈의 의미 찾기',
            color: Colors.indigo,
            onTap: () => context.push('/dream'),
          ),
          _buildMenuCard(
            context,
            icon: Icons.grid_view_rounded,
            title: '테마 운세',
            subtitle: '다양한 상황별 운세',
            color: Colors.teal,
            onTap: () => context.push('/theme-fortune'),
          ),
          _buildMenuCard(
            context,
            icon: Icons.style,
            title: '타로',
            subtitle: '오늘의 카드',
            color: Colors.deepPurpleAccent,
            onTap: () => context.push('/tarot'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
