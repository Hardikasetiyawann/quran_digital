import '../../domain/entities/surah.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/juz_verse.dart';
import '../../../last_read/domain/entities/last_read.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_remote_datasource.dart';
import '../datasources/quran_local_datasource.dart';
import '../models/juz_verse_model.dart';
import '../../../last_read/domain/repositories/last_read_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource remote;
  final QuranLocalDataSource local;
  final LastReadRepository lastReadRepository;

  QuranRepositoryImpl(this.remote, this.local, this.lastReadRepository);

  @override
  Future<List<Surah>> getSurahList() async {
    try {
      final cached = await local.getCachedSurahList();
      if (cached.isNotEmpty) return cached;

      final remoteData = await remote.getSurahList();
      await local.cacheSurahList(remoteData);
      return remoteData;
    } catch (e) {
      final cached = await local.getCachedSurahList();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Verse>> getSurahDetail(int id) {
    // For Surah Detail (Verses), we keep it remote for now but we can cache if needed.
    // User specifically asked to optimize fetching.
    // Let's rely on standard GET.
    // Also save "Last Read" when fetching detail (assuming this means user is reading)
    // Ideally this should be explicit, but for now we hook it here or in UI.
    return remote.getSurahDetail(id);
  }

  @override
  Future<List<int>> getJuzList() async {
    return List.generate(30, (i) => i + 1);
  }

  @override
  Future<List<JuzVerse>> getJuzDetail(int juz) async {
    try {
      final cached = await local.getCachedJuzDetail(juz);

      // Even if cached, we check if surah names are missing (legacy or extraction error)
      if (cached.isNotEmpty && !cached.any((e) => e.surahName == 'Unknown Surah')) {
        return cached;
      }

      final remoteData = await remote.getJuzDetail(juz);
      final surahs = await getSurahList();

      // Mapping surah ranges to find which surah an inQuran belongs to
      List<int> surahStartIndices = [];
      int currentTotal = 0;
      for (var s in surahs) {
        surahStartIndices.add(currentTotal + 1);
        currentTotal += s.verses;
      }

      final List<JuzVerseModel> mappedData = remoteData.map((v) {
        int surahIndex = -1;
        // Find surah that contains this inQuran ayah
        for (int i = 0; i < surahStartIndices.length; i++) {
          if (v.inQuran >= surahStartIndices[i]) {
            surahIndex = i;
          } else {
            break;
          }
        }

        final foundSurah = surahIndex != -1 ? surahs[surahIndex] : null;

        return JuzVerseModel(
          juz: v.juz,
          ayahNumber: v.ayahNumber,
          inQuran: v.inQuran,
          surahNumber: foundSurah?.number ?? v.surahNumber,
          surahName: foundSurah?.latin ?? v.surahName,
          arab: v.arab,
          translation: v.translation,
          audio: v.audio,
        );
      }).toList();

      await local.cacheJuzDetail(juz, mappedData);
      return mappedData.cast<JuzVerse>();
    } catch (e) {
      final cached = await local.getCachedJuzDetail(juz);
      if (cached.isNotEmpty) {
        return cached.cast<JuzVerse>();
      }
      rethrow;
    }
  }
  
  @override
  Future<void> saveLastRead(String surahName, int surahId, int ayahNumber) async {
    await local.saveLastRead(surahName, surahId, ayahNumber);
    await lastReadRepository.saveLastRead(
      LastRead(
        surahId: surahId,
        surahName: surahName,
        ayahNumber: ayahNumber,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Map<String, dynamic>?> getLastRead() {
    return local.getLastRead();
  }

  @override
  Future<List<dynamic>> searchQuran(String query) async {
    final List<dynamic> results = [];
    final keyword = query.toLowerCase();

    // 1. Search in Surahs
    final surahs = await getSurahList();
    final surahMatches = surahs.where((s) =>
        s.latin.toLowerCase().contains(keyword) ||
        s.meaning.toLowerCase().contains(keyword) ||
        s.number.toString() == keyword);
    results.addAll(surahMatches);

    // 2. Search in Ayahs (iterate all 30 juz from cache)
    for (int j = 1; j <= 30; j++) {
      final juzVerses = await local.getCachedJuzDetail(j);
      if (juzVerses.isNotEmpty) {
        final verseMatches = juzVerses.where((v) =>
            v.translation.toLowerCase().contains(keyword) ||
            v.arab.contains(query)); // Raw query for Arabic works better usually
        results.addAll(verseMatches);
      }
    }

    return results;
  }
}
