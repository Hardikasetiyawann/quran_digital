import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/last_read_bloc.dart';
import '../bloc/last_read_event.dart';
import '../bloc/last_read_state.dart';
import '../../../quran/presentation/pages/surah_detail_page.dart';
import '../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../../core/utils/app_colors.dart';

class LastReadPage extends StatefulWidget {
  const LastReadPage({super.key});

  @override
  State<LastReadPage> createState() => _LastReadPageState();
}

class _LastReadPageState extends State<LastReadPage> {
  @override
  void initState() {
    super.initState();
    context.read<LastReadBloc>().add(LoadLastReadHistory());
  }

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
        title: const Text(
          'Terakhir Dibaca',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<LastReadBloc, LastReadState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: AppColors.cardGrey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat bacaan',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: state.history.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.backgroundSecondary,
            ),
            itemBuilder: (_, i) {
              final h = state.history[i];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<QuranBloc>(),
                        child: SurahDetailPage(
                          surahId: h.surahId,
                          surahName: h.surahName,
                          targetAyah: h.ayahNumber,
                        ),
                      ),
                    ),
                  ).then((_) {
                    // Refresh history when coming back from detail
                    if (mounted) {
                      context.read<LastReadBloc>().add(LoadLastReadHistory());
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      _buildNumberIcon(h.surahId),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.surahName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ayat ke-${h.ayahNumber}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNumberIcon(int number) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0.785,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Text(
            number.toString(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
