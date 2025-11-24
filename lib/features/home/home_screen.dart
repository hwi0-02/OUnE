import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/features/home/daily_fortune_view.dart';
import 'package:app_project/features/home/home_tab_screen.dart';
import 'package:app_project/features/home/detailed_fortune_screen.dart';
import 'package:app_project/features/home/home_provider.dart';
import 'package:app_project/features/more/more_screen.dart';
import 'package:app_project/features/settings/my_screen.dart';
import 'package:app_project/features/tarot/tarot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeTabIndexProvider);

    final List<Widget> screens = [
      const HomeTabScreen(),
      const DetailedFortuneScreen(),
      const MoreScreen(),
      const MyScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(homeTabIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryPink,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: '오늘의 운세'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: '더보기'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
        ],
      ),
    );
  }
}
