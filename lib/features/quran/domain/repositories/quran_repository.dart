import '../entities/surah.dart';
import '../entities/verse.dart';
import '../entities/juz_verse.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahList();
  Future<List<Verse>> getSurahDetail(int surahId);

  /// hanya list angka 1–30
  Future<List<int>> getJuzList();

  /// detail ayat dalam satu juz
  Future<List<JuzVerse>> getJuzDetail(int juz);

  Future<void> saveLastRead(String surahName, int surahId, int ayahNumber);
  Future<Map<String, dynamic>?> getLastRead();

  Future<List<dynamic>> searchQuran(String query);
}
