import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import 'surah_detail_page.dart';

import '../../../../core/utils/app_colors.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<QuranBloc>();
    if (bloc.state.surahs.isEmpty) {
      bloc.add(LoadSurahList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen: (prev, curr) =>
          prev.surahs != curr.surahs || prev.loadingSurah != curr.loadingSurah,
      builder: (context, state) {
        if (state.loadingSurah && state.surahs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.surahs.isEmpty) {
          return const Center(child: Text('Tidak ada data surah'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<QuranBloc>().add(LoadSurahList());
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.surahs.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.1),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final surah = state.surahs[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.star_outline_rounded, color: AppColors.primary.withOpacity(0.3), size: 40),
                    Text(
                      surah.number.toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  surah.latin,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${surah.revelation} • ${surah.verses} AYAT',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  surah.name,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<QuranBloc>(),
                        child: SurahDetailPage(
                          surahId: surah.number,
                          surahName: surah.latin,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
