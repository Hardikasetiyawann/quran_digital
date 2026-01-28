import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quran_digital/features/quran/domain/usecases/get_juz_detail.dart';
import 'package:quran_digital/features/quran/presentation/pages/juz_page.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/quran_remote_datasource.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/usecases/get_juz_list.dart';
import '../../domain/usecases/get_surah_detail.dart';
import '../../domain/usecases/get_surah_list.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../pages/surah_page.dart';

import '../../../../core/utils/app_colors.dart';

class QuranHomePage extends StatelessWidget {
  const QuranHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Al-Qur’an',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textSecondary),
              onPressed: () {},
            ),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppColors.purpleGradient,
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
                              const Row(
                                children: [
                                  Icon(Icons.import_contacts, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Terakhir Baca',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
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
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                ayahNo > 0 ? 'Ayat No: $ayahNo' : 'Ketuk surah untuk mulai membaca',
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
                );
              },
            ),
              
              const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: [
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
      ),
    );
  }
}
