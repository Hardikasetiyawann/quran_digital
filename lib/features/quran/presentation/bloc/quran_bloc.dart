import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_surah_list.dart';
import '../../domain/usecases/get_surah_detail.dart';
import '../../domain/usecases/get_juz_list.dart';
import '../../domain/usecases/get_juz_detail.dart';
import 'quran_event.dart';
import 'quran_state.dart';

import '../../domain/repositories/quran_repository.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetSurahList getSurahList;
  final GetSurahDetail getSurahDetail;
  final GetJuzList getJuzList;
  final GetJuzDetail getJuzDetail;
  final QuranRepository repository;

  QuranBloc(
    this.getSurahList,
    this.getSurahDetail,
    this.getJuzList,
    this.getJuzDetail,
    this.repository,
  ) : super(const QuranState()) {
    on<LoadSurahList>(_onLoadSurahList);
    on<LoadSurahDetail>(_onLoadSurahDetail);
    on<LoadJuzList>(_onLoadJuzList);
    on<LoadJuzDetail>(_onLoadJuzDetail);
    on<LoadLastRead>(_onLoadLastRead);
    on<SaveLastRead>(_onSaveLastRead);
  }

  Future<void> _onLoadSurahList(
    LoadSurahList event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(loadingSurah: true));
    try {
      final data = await getSurahList();
      emit(state.copyWith(surahs: data, loadingSurah: false));
    } catch (e) {
      emit(state.copyWith(loadingSurah: false, error: e.toString()));
    }
  }

  Future<void> _onLoadSurahDetail(
    LoadSurahDetail event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(loadingDetail: true));
    try {
      final data = await getSurahDetail(event.surahId);
      emit(state.copyWith(verses: data, loadingDetail: false));
    } catch (e) {
      emit(state.copyWith(loadingDetail: false, error: e.toString()));
    }
  }

  Future<void> _onLoadJuzList(
    LoadJuzList event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(loadingJuz: true));
    try {
      final data = await getJuzList();
      emit(state.copyWith(juzList: data, loadingJuz: false));
    } catch (e) {
      emit(state.copyWith(loadingJuz: false, error: e.toString()));
    }
  }

  Future<void> _onLoadJuzDetail(
    LoadJuzDetail event,
    Emitter<QuranState> emit,
  ) async {
    emit(
      state.copyWith(
        loadingJuz: true,
        juzVerses: [],
        error: null,
      ),
    );

    try {
      final data = await getJuzDetail(event.juz);
      emit(state.copyWith(juzVerses: data, loadingJuz: false));
    } catch (e) {
      emit(state.copyWith(loadingJuz: false, error: e.toString()));
    }
  }

  Future<void> _onLoadLastRead(
    LoadLastRead event,
    Emitter<QuranState> emit,
  ) async {
    try {
      final data = await repository.getLastRead();
      emit(state.copyWith(lastRead: data));
    } catch (_) {
      // Ignore error for last read
    }
  }

  Future<void> _onSaveLastRead(
    SaveLastRead event,
    Emitter<QuranState> emit,
  ) async {
    try {
      await repository.saveLastRead(event.surahName, event.surahId, event.ayahNumber);
      add(LoadLastRead()); // Reload to update UI
    } catch (_) {}
  }
}
