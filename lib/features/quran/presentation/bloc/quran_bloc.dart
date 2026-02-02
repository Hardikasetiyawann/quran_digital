import 'package:flutter_bloc/flutter_bloc.dart';
import 'quran_event.dart';
import 'quran_state.dart';

import '../../domain/repositories/quran_repository.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final QuranRepository repository;

  QuranBloc(this.repository) : super(const QuranState()) {
    on<LoadSurahList>(_onLoadSurahList);
    on<LoadSurahDetail>(_onLoadSurahDetail);
    on<LoadJuzList>(_onLoadJuzList);
    on<LoadJuzDetail>(_onLoadJuzDetail);
    on<LoadLastRead>(_onLoadLastRead);
    on<SaveLastRead>(_onSaveLastRead);
    on<SearchQuran>(_onSearchQuran);
  }

  Future<void> _onSearchQuran(
    SearchQuran event,
    Emitter<QuranState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      return;
    }
    emit(state.copyWith(isSearching: true));
    try {
      final results = await repository.searchQuran(event.query);
      emit(state.copyWith(searchResults: results, isSearching: false));
    } catch (e) {
      emit(state.copyWith(isSearching: false, error: e.toString()));
    }
  }

  Future<void> _onLoadSurahList(
    LoadSurahList event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(loadingSurah: true));
    try {
      final data = await repository.getSurahList();
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
      final data = await repository.getSurahDetail(event.surahId);
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
      final data = await repository.getJuzList();
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
      final data = await repository.getJuzDetail(event.juz);
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
