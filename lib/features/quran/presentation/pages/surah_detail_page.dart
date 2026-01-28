import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';

import '../../../../core/utils/app_colors.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final AudioPlayer _audioPlayer;
  int? _playingAyah;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() => _playingAyah = null);
      }
    });

    context.read<QuranBloc>().add(LoadSurahDetail(widget.surahId));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAyah(String url, int ayahNumber) async {
    // Save last read
    context.read<QuranBloc>().add(
          SaveLastRead(
            widget.surahName,
            widget.surahId,
            ayahNumber,
          ),
        );

    if (_playingAyah == ayahNumber) return;

    await _audioPlayer.stop();
    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

    setState(() => _playingAyah = ayahNumber);

    await _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        final surah = state.surahs.firstWhere(
          (s) => s.number == widget.surahId,
          orElse: () => state.surahs.first, // Fallback
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              surah.latin,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.textSecondary),
                onPressed: () {},
              ),
            ],
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                // Hero Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AppColors.purpleGradient,
                  ),
                  child: Column(
                    children: [
                      Text(
                        surah.latin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        surah.meaning,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.35), thickness: 1),
                      const SizedBox(height: 16),
                      Text(
                        '${surah.revelation.toUpperCase()} • ${surah.verses} AYAT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Bismillah Calligraphy (Text based)
                      const Text(
                        'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Content
                if (state.loadingDetail)
                  const Center(child: CircularProgressIndicator())
                else if (state.verses.isEmpty)
                  const Center(child: Text('Ayat tidak ditemukan'))
                else
                  ...state.verses.map((v) {
                    final isPlaying = _playingAyah == v.number;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Ayah Header Card
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.cardGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 27,
                                  height: 27,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    v.number.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () => _playAyah(v.audio, v.number),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.bookmark_border_rounded, color: AppColors.primary),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Arabic
                          Text(
                            v.arab,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                              fontFamily: 'Amiri',
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Translation
                          Text(
                            v.translation,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
