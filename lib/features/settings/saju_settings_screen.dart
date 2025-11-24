import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/models/saju_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SajuSettingsScreen extends StatefulWidget {
  const SajuSettingsScreen({super.key});

  @override
  State<SajuSettingsScreen> createState() => _SajuSettingsScreenState();
}

class _SajuSettingsScreenState extends State<SajuSettingsScreen> {
  late SajuSettings _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final useYaJaSi = prefs.getBool('saju_useYaJaSi') ?? false;
    final useSolarCorrection = prefs.getBool('saju_useSolarCorrection') ?? true;
    
    setState(() {
      _settings = SajuSettings(
        useYaJaSi: useYaJaSi,
        useSolarTimeCorrection: useSolarCorrection,
      );
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('saju_useYaJaSi', _settings.useYaJaSi);
    await prefs.setBool('saju_useSolarCorrection', _settings.useSolarTimeCorrection);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('설정이 저장되었습니다'),
          backgroundColor: AppTheme.primaryPink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryPink),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('사주 정밀도 설정'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildSettingCard(
            title: '진태양시 보정',
            subtitle: '경도 차이와 과거 표준시 변경을 반영하여 정확한 시주를 계산합니다',
            value: _settings.useSolarTimeCorrection,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(useSolarTimeCorrection: value);
              });
              _saveSettings();
            },
            icon: Icons.wb_sunny,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: '야자시(夜子時) 적용',
            subtitle: '23:00-23:59를 다음 날 자시로 처리하되 일주는 유지합니다',
            value: _settings.useYaJaSi,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(useYaJaSi: value);
              });
              _saveSettings();
            },
            icon: Icons.nights_stay,
            color: Colors.indigo,
          ),
          const SizedBox(height: 24),
          _buildCorrectionExample(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPink.withOpacity(0.2),
            AppTheme.primaryPink.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryPink.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.primaryPink,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                '정밀 사주 계산',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '천문학적으로 정확한 사주팔자 산출을 위한 고급 설정입니다. '
            '특히 시주(時柱) 계산의 정확도를 크게 향상시킵니다.',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: color,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8, left: 44),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildCorrectionExample() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppTheme.pointGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '왜 필요한가요?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExampleRow(
            '진태양시 보정',
            '서울은 표준시보다 약 30분 늦게 태양이 남중합니다. '
            '13:00 출생자의 실제 태양시는 12:30이므로 오시(午時)가 됩니다.',
          ),
          const SizedBox(height: 12),
          _buildExampleRow(
            '과거 표준시 반영',
            '1954-1961년에는 한국 독자 표준시(127.5°)를 사용했습니다. '
            '이 시기 출생자는 다른 보정값이 적용됩니다.',
          ),
          const SizedBox(height: 12),
          _buildExampleRow(
            '야자시 적용',
            '23:00-23:59 출생자의 경우, 시주는 자시(子時)지만 '
            '일주(日柱)는 당일로 유지하는 전통 방식입니다.',
          ),
        ],
      ),
    );
  }

  Widget _buildExampleRow(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.primaryPink,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
