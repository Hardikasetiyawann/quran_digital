import 'package:equatable/equatable.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/juz_verse.dart';

class QuranState extends Equatable {
  /// Surah
  final List<Surah> surahs;
  final bool loadingSurah;

  /// Surah detail
  final List<Verse> verses;
  final bool loadingDetail;

  /// Juz
  final List<int> juzList;
  final List<JuzVerse> juzVerses;
  final bool loadingJuz;

  final String? error;
  final Map<String, dynamic>? lastRead;
  final List<dynamic> searchResults;
  final bool isSearching;

  const QuranState({
    this.surahs = const [],
    this.verses = const [],
    this.juzList = const [],
    this.juzVerses = const [],
    this.loadingSurah = false,
    this.loadingDetail = false,
    this.loadingJuz = false,
    this.error,
    this.lastRead,
    this.searchResults = const [],
    this.isSearching = false,
  });

  QuranState copyWith({
    List<Surah>? surahs,
    List<Verse>? verses,
    List<int>? juzList,
    List<JuzVerse>? juzVerses,
    bool? loadingSurah,
    bool? loadingDetail,
    bool? loadingJuz,
    String? error,
    Map<String, dynamic>? lastRead,
    List<dynamic>? searchResults,
    bool? isSearching,
  }) {
    return QuranState(
      surahs: surahs ?? this.surahs,
      verses: verses ?? this.verses,
      juzList: juzList ?? this.juzList,
      juzVerses: juzVerses ?? this.juzVerses,
      loadingSurah: loadingSurah ?? this.loadingSurah,
      loadingDetail: loadingDetail ?? this.loadingDetail,
      loadingJuz: loadingJuz ?? this.loadingJuz,
      error: error,
      lastRead: lastRead ?? this.lastRead,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
    surahs,
    verses,
    juzList,
    juzVerses,
    loadingSurah,
    loadingDetail,
    loadingJuz,
    error,
    lastRead,
    searchResults,
    isSearching,
  ];
}
