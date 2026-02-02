import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../quran/domain/entities/surah.dart';
import '../../../quran/domain/entities/juz_verse.dart';
import '../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../quran/presentation/bloc/quran_event.dart';
import '../../../quran/presentation/bloc/quran_state.dart';
import '../../../quran/presentation/pages/surah_detail_page.dart';
import '../../../quran/presentation/pages/juz_detail_page.dart';
import '../../../../core/utils/app_colors.dart';

class QuranSearchDelegate extends SearchDelegate {
  final List<Surah> surahs;

  QuranSearchDelegate(this.surahs);

  @override
  String get searchFieldLabel => 'Cari surah atau ayat...';

  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(fontSize: 16, color: AppColors.textPrimary);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // ==============================
  // RESULTS
  // ==============================
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResult(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResult(context);
  }

  Widget _buildSearchResult(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Ketik kata kunci pencarian'),
      );
    }

    // Dispatch search event to Bloc
    // Note: SearchDelegate buildResults/buildSuggestions are called frequently.
    // Bloc will handle the actual logic.
    context.read<QuranBloc>().add(SearchQuran(query));

    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state.isSearching && state.searchResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.searchResults.isEmpty) {
          return const Center(
            child: Text('Tidak ditemukan'),
          );
        }

        final surahMatches = state.searchResults.whereType<Surah>().toList();
        final verseMatches = state.searchResults.whereType<JuzVerse>().toList();

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // ==================
            // SURAH RESULT
            // ==================
            if (surahMatches.isNotEmpty) ...[
              _sectionTitle('Surah'),
              ...surahMatches.map((s) {
                return ListTile(
                  leading: _buildNumberIcon(s.number),
                  title: Text(
                    s.latin,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(s.meaning, style: const TextStyle(fontSize: 12)),
                  trailing: Text(
                    s.name,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    close(context, null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<QuranBloc>(),
                          child: SurahDetailPage(
                            surahId: s.number,
                            surahName: s.latin,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],

            // ==================
            // AYAT RESULT
            // ==================
            if (verseMatches.isNotEmpty) ...[
              _sectionTitle('Ayat'),
              ...verseMatches.map((v) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: _buildNumberIcon(v.ayahNumber),
                  title: Text(
                    v.translation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    '${v.surahName} • Ayat ${v.ayahNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                  onTap: () {
                    close(context, null);
                    // Find if match is in Surah Detail or Juz Detail
                    // For simplicity, navigate to Juz page since it carries the JuzVerse data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<QuranBloc>(),
                          child: JuzDetailPage(
                            juz: v.juz,
                            targetInQuran: v.inQuran,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNumberIcon(int number) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
