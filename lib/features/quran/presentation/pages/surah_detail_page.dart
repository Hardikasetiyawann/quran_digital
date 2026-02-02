import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';

import '../../../../core/utils/app_colors.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


// ... (imports)

class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final String surahName;
  final int? targetAyah; // New parameter

  const SurahDetailPage({
    super.key,
    required this.surahId,
    required this.surahName,
    this.targetAyah,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final AudioPlayer _audioPlayer;
  final ItemScrollController _itemScrollController = ItemScrollController(); // Scroll Controller
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  
  int? _playingAyah;
  bool _initialScrollDone = false;
  int? _lastSavedAyah;
  late final StreamSubscription<PlayerState> _playerSubscription;


  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _itemPositionsListener.itemPositions.addListener(_onScrollAyah);
    context.read<QuranBloc>().add(LoadSurahDetail(widget.surahId));
    _playerSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) setState(() => _playingAyah = null);
      }
    });

    context.read<QuranBloc>().add(LoadSurahDetail(widget.surahId));
  }

  // Effect to scroll once data is loaded
  void _scrollToTarget() {
    if (_initialScrollDone || widget.targetAyah == null) return;
    
    // Check if verses are loaded (checked in build)
    // We schedule jump after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_itemScrollController.isAttached) {
             // Index 0 is Hero Card.
             // Verse 1 is Index 1. 
             // Verse X is Index X.
             _itemScrollController.jumpTo(index: widget.targetAyah!);
             setState(() => _initialScrollDone = true);
        }
    });
  }
  void _onScrollAyah() {
  final positions = _itemPositionsListener.itemPositions.value;

  if (positions.isEmpty) return;

  // Ambil ayat yang PALING ATAS di layar
  final firstVisible = positions
      .where((p) => p.itemLeadingEdge >= 0)
      .reduce((min, p) =>
          p.itemLeadingEdge < min.itemLeadingEdge ? p : min);

  final index = firstVisible.index;

  // index 0 = hero card
  if (index <= 0) return;

  final ayahNumber = index; // ayat = index

  if (_lastSavedAyah == ayahNumber) return;

  _lastSavedAyah = ayahNumber;

  context.read<QuranBloc>().add(
        SaveLastRead(
          widget.surahName,
          widget.surahId,
          ayahNumber,
        ),
      );
}


  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScrollAyah);
    _playerSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
  
  Future<void> _playAyah(String audioUrl, int ayahNumber) async {
    if (_playingAyah == ayahNumber) {
      await _audioPlayer.pause();
      setState(() => _playingAyah = null);
      return;
    }

    try {
      // Stop any currently playing audio first
      await _audioPlayer.stop();
      
      if (mounted) setState(() => _playingAyah = ayahNumber);
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      if (mounted) setState(() => _playingAyah = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memutar audio: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        final surahIndex = state.surahs.indexWhere((s) => s.number == widget.surahId);
        final surah = surahIndex != -1 ? state.surahs[surahIndex] : null;

        if (surah == null && state.surahs.isNotEmpty) {
           // Fallback if not found but list not empty
        }

        // Trigger scroll if verses loaded
        if (state.verses.isNotEmpty && !_initialScrollDone && widget.targetAyah != null) {
           _scrollToTarget();
        }

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
              surah?.latin ?? widget.surahName,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
          ),
          body: state.loadingDetail && state.verses.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.verses.isEmpty 
               ? const Center(child: Text('Ayat tidak ditemukan')) 
               : ScrollablePositionedList.separated(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  itemCount: state.verses.length + 1, // +1 for Hero Card
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Hero Card
                      return Container(
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
                                right: -30,
                                bottom: -30,
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    size: 200,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  children: [
                                    Text(
                                      surah?.latin ?? widget.surahName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (surah != null) ...[
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
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 32),
                                    const Text(
                                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontFamily: 'Amiri',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                    }

                    final v = state.verses[index - 1];
                    final isPlaying = _playingAyah == v.number;
                    final isTarget = widget.targetAyah == v.number;

                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Ayah Header Card
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    v.number.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                  onPressed: () => _playAyah(v.audio, v.number),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.primary, size: 28),
                                  onPressed: () {
                                    context.read<QuranBloc>().add(
                                      SaveLastRead(widget.surahName, widget.surahId, v.number),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Tersimpan: ${widget.surahName} ayat ${v.number}')),
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Arabic
                          Text(
                            v.arab,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                              fontFamily: 'Amiri',
                              backgroundColor: isTarget ? AppColors.primary.withOpacity(0.1) : null,
                            ),
                          ),
                          if (isTarget) const SizedBox(height: 8),
                          const SizedBox(height: 16),
                          // Translation
                          Text(
                            v.translation,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Divider(color: AppColors.backgroundSecondary, thickness: 1),
                        ],
                      ),
                    );
                  },
               ),
        );
      },
    );
  }
}
