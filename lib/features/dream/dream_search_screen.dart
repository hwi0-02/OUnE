import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/services/dream_database.dart';
import 'package:flutter/material.dart';

/// 꿈해몽 검색 화면
class DreamSearchScreen extends StatefulWidget {
  const DreamSearchScreen({super.key});

  @override
  State<DreamSearchScreen> createState() => _DreamSearchScreenState();
}

class _DreamSearchScreenState extends State<DreamSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DreamInterpretation> _searchResults = [];
  List<DreamInterpretation> _popularDreams = DreamDatabase.getPopular(limit: 10);
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _searchResults = DreamDatabase.search(query);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('꿈해몽'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // 검색 바
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '꿈에서 본 것을 검색하세요 (예: 뱀, 물)',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryPink),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryPink, width: 2),
                ),
              ),
            ),
          ),

          // 결과 영역
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : _buildPopularDreams(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade700),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            Text(
              '다른 키워드로 검색해보세요',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildDreamCard(_searchResults[index]);
      },
    );
  }

  Widget _buildPopularDreams() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Row(
          children: [
            const Icon(Icons.trending_up, color: AppTheme.primaryPink),
            const SizedBox(width: 8),
            const Text(
              '인기 꿈해몽 Top 10',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._popularDreams.map((dream) => _buildDreamCard(dream)),
      ],
    );
  }

  Widget _buildDreamCard(DreamInterpretation dream) {
    Color luckyColor;
    IconData luckyIcon;
    
    if (dream.luckySign.contains('대길')) {
      luckyColor = Colors.orange;
      luckyIcon = Icons.star;
    } else if (dream.luckySign.contains('길')) {
      luckyColor = AppTheme.primaryPink;
      luckyIcon = Icons.favorite;
    } else if (dream.luckySign.contains('흉')) {
      luckyColor = Colors.grey;
      luckyIcon = Icons.warning;
    } else {
      luckyColor = AppTheme.secondaryBlue;
      luckyIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: luckyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(luckyIcon, size: 16, color: luckyColor),
                    const SizedBox(width: 4),
                    Text(
                      dream.keyword,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: luckyColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: luckyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dream.luckySign,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: luckyColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dream.meaning,
            style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
          ),
          if (dream.relatedKeywords.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: dream.relatedKeywords.map((keyword) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    keyword,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
