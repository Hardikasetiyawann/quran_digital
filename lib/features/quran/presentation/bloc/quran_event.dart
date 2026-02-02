import 'package:equatable/equatable.dart';

abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object?> get props => [];
}

/// SURAH
class LoadSurahList extends QuranEvent {}

class LoadSurahDetail extends QuranEvent {
  final int surahId;
  const LoadSurahDetail(this.surahId);

  @override
  List<Object?> get props => [surahId];
}

/// JUZ
class LoadJuzList extends QuranEvent {}

class LoadJuzDetail extends QuranEvent {
  final int juz;
  const LoadJuzDetail(this.juz);

  @override
  List<Object?> get props => [juz];
}

class LoadLastRead extends QuranEvent {}

class SaveLastRead extends QuranEvent {
  final String surahName;
  final int surahId;
  final int ayahNumber;
  const SaveLastRead(this.surahName, this.surahId, this.ayahNumber);
  @override
  List<Object> get props => [surahName, surahId, ayahNumber];
}

class SearchQuran extends QuranEvent {
  final String query;
  const SearchQuran(this.query);

  @override
  List<Object?> get props => [query];
}
