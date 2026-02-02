import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../quran/presentation/bloc/quran_state.dart';
import '../widgets/quran_search_delegate.dart';
import '../../../../core/utils/app_colors.dart';

import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pencarian',
          style: GoogleFonts.outfit(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state.surahs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // SEARCH BAR
                GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: QuranSearchDelegate(state.surahs),
                    );
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardGrey),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Cari surah atau ayat...',
                          style: GoogleFonts.outfit(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // INFO / EMPTY STATE
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 100,
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Cari ayat atau surah\nAl-Qur’an',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Temukan kemudahan dalam mencari\nsetiap baris firman-Nya',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
