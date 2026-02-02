import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../../../../core/utils/app_colors.dart';

class JuzDetailPage extends StatefulWidget {
  final int juz;
  final int? targetInQuran;
  const JuzDetailPage({super.key, required this.juz, this.targetInQuran});

  @override
  State<JuzDetailPage> createState() => _JuzDetailPageState();
}

class _JuzDetailPageState extends State<JuzDetailPage> {
  late final AudioPlayer _player;
  int? _playingAyah;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  late final StreamSubscription<PlayerState> _playerSubscription;
  int? _lastSavedInQuran;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _itemPositionsListener.itemPositions.addListener(_onScrollAyah);

    _playerSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) setState(() => _playingAyah = null);
      }
    });

    context.read<QuranBloc>().add(LoadJuzDetail(widget.juz));
    // Ensure surah list is available for mapping in Repo
    if (context.read<QuranBloc>().state.surahs.isEmpty) {
      context.read<QuranBloc>().add(LoadSurahList());
    }
  }

  void _onScrollAyah() {
    final positions = _itemPositionsListener.itemPositions.value;
    final state = context.read<QuranBloc>().state;

    if (positions.isEmpty || state.juzVerses.isEmpty) return;

    // Get the first visible verse
    final firstVisible = positions
        .where((p) => p.itemLeadingEdge >= 0)
        .reduce((min, p) => p.itemLeadingEdge < min.itemLeadingEdge ? p : min);

    final index = firstVisible.index;
    if (index < 0 || index >= state.juzVerses.length) return;

    final verse = state.juzVerses[index];
    
    // Only save if it's a different verse
    if (_lastSavedInQuran == verse.inQuran) return;

    _lastSavedInQuran = verse.inQuran;
    context.read<QuranBloc>().add(
      SaveLastRead(verse.surahName, verse.surahNumber, verse.ayahNumber),
    );
  }

  void _scrollToTarget(List juzVerses) {
    if (widget.targetInQuran == null) return;
    
    final index = juzVerses.indexWhere((v) => v.inQuran == widget.targetInQuran);
    if (index != -1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _scrollController.scrollTo(
            index: index,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScrollAyah);
    _playerSubscription.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _play(String url, int inQuran, String surahName, int surahId, int ayahNo) async {
    if (_playingAyah == inQuran) {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
      if (mounted) setState(() {});
      return;
    }

    await _player.stop();
    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    
    if (mounted) setState(() => _playingAyah = inQuran);
    await _player.play();

    // Auto update last read when audio starts
    if (mounted) {
      context.read<QuranBloc>().add(SaveLastRead(surahName, surahId, ayahNo));
    }
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
        title: Text(
          'Juz ${widget.juz}',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state.loadingJuz && state.juzVerses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.juzVerses.isEmpty) {
            return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
          }

          if (state.juzVerses.isEmpty) {
            return const Center(child: Text('Memuat ayat...'));
          }

          // Trigger scroll to target if available
          _scrollToTarget(state.juzVerses);

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<QuranBloc>().add(LoadJuzDetail(widget.juz));
            },
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemPositionsListener: _itemPositionsListener,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: state.juzVerses.length,
              itemBuilder: (_, i) {
                final v = state.juzVerses[i];
                final isPlaying = _playingAyah == v.inQuran;

                return InkWell(
                  onTap: () {
                    context.read<QuranBloc>().add(SaveLastRead(v.surahName, v.surahNumber, v.ayahNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Riwayat baca diperbarui: ${v.surahName} ayat ${v.ayahNumber}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                                v.ayahNumber.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                v.surahName,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                (isPlaying && _player.playing) 
                                    ? Icons.pause_circle_filled_rounded 
                                    : Icons.play_circle_filled_rounded,
                                color: AppColors.primary,
                                size: 32,
                              ),
                              onPressed: () => _play(v.audio, v.inQuran, v.surahName, v.surahNumber, v.ayahNumber),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.primary, size: 28),
                              onPressed: () {
                                context.read<QuranBloc>().add(SaveLastRead(
                                  v.surahName,
                                  v.surahNumber,
                                  v.ayahNumber,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Tersimpan: ${v.surahName} ayat ${v.ayahNumber}')),
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
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
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
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(color: AppColors.backgroundSecondary, thickness: 1),
                    ],
                  ),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
