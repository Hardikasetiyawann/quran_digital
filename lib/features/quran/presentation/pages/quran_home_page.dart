import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_state.dart';
import '../../../search/presentation/widgets/quran_search_delegate.dart';
import 'juz_page.dart';
import 'surah_page.dart';
import 'surah_detail_page.dart';

class QuranHomePage extends StatelessWidget {
  const QuranHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Al-Qur’an',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: false,
          actions: [
            BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 28),
                  onPressed: () {
                    if (state.surahs.isNotEmpty) {
                      showSearch(
                        context: context,
                        delegate: QuranSearchDelegate(state.surahs),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menunggu data surah...')),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Welcome / Last Read Card
            BlocBuilder<QuranBloc, QuranState>(
              builder: (context, state) {
                final lastRead = state.lastRead;
                final surahName = lastRead?['surahName'] ?? 'Belum ada';
                final ayahNo = lastRead?['ayahNumber'] ?? 0;

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: InkWell(
                    onTap: () {
                      if (lastRead == null) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<QuranBloc>(),
                            child: SurahDetailPage(
                              surahId: lastRead['surahId'],
                              surahName: lastRead['surahName'],
                              targetAyah: lastRead['ayahNumber'],
                            ),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 130),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AppColors.premiumGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -20,
                            right: -10,
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 150,
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.import_contacts, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Terakhir Baca',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  surahName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ayahNo > 0 ? 'Ayat ke-$ayahNo' : 'Ketuk untuk mulai membaca',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: 'Surah'),
                Tab(text: 'Juz'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [SurahPage(), JuzPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
