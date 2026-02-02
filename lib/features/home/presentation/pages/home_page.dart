import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_digital/core/utils/app_colors.dart';
import 'package:quran_digital/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:quran_digital/features/quran/presentation/bloc/quran_state.dart';
import 'package:quran_digital/features/search/presentation/pages/search_page.dart';
import 'package:quran_digital/features/last_read/presentation/pages/last_read_page.dart';

import 'package:quran_digital/features/prayer/presentation/pages/prayer_page.dart';

import '../../../quran/presentation/pages/quran_home_page.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../domain/entities/home_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _navigate(BuildContext context, HomeMenuType type) async {
    switch (type) {
      case HomeMenuType.quran:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuranHomePage()),
        );
        break;
      case HomeMenuType.lastRead:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LastReadPage(),
          ),
        );
        break;

      case HomeMenuType.search:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<QuranBloc>(),
              child: const SearchPage(),
            ),
          ),
        );
        break;

      case HomeMenuType.prayer:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerPage()),
        );
        break;
      case HomeMenuType.settings:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur Pengaturan segera hadir')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(LoadHomeMenus());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildLastReadHero(context),
              const SizedBox(height: 32),
              _buildMenuGrid(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assalamualaikum',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ayo Mengaji',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLastReadHero(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        final lastRead = state.lastRead;

        return InkWell(
          onTap: () {
            if (lastRead == null) return;
            _navigate(context, HomeMenuType.quran);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
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
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.2,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Terakhir Dibaca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        lastRead?['surahName'] ?? 'Belum ada bacaan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastRead != null ? 'Ayat ke-${lastRead['ayahNumber']}' : 'Ayo mulai membaca',
                        style: const TextStyle(
                          color: Colors.white,
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
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: screenWidth > 600 ? 1.3 : 1.1,
            ),
            itemCount: state.menus.length,
            itemBuilder: (context, index) {
              final menu = state.menus[index];
              return _buildMenuCard(context, menu);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, HomeMenu menu) {
    IconData iconData;
    switch (menu.type) {
      case HomeMenuType.quran:
        iconData = Icons.auto_stories;
        break;
      case HomeMenuType.lastRead:
        iconData = Icons.history;
        break;
      case HomeMenuType.search:
        iconData = Icons.search;
        break;
      case HomeMenuType.prayer:
        iconData = Icons.access_time_filled;
        break;
      case HomeMenuType.settings:
        iconData = Icons.settings;
        break;
    }

    return InkWell(
      onTap: () => _navigate(context, menu.type),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.cardGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              menu.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
