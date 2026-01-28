import '../../domain/entities/surah.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/juz_verse.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_remote_datasource.dart';
import '../datasources/quran_local_datasource.dart';
import '../models/juz_verse_model.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource remote;
  final QuranLocalDataSource local;

  QuranRepositoryImpl(this.remote, this.local);

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
      if (cached.isNotEmpty) return cached;

      final remoteData = (await remote.getJuzDetail(juz))
          .map((e) => JuzVerseModel.fromEntity(e))
          .toList();
          
      await local.cacheJuzDetail(juz, remoteData);
      return remoteData;
    } catch (e) {
      final cached = await local.getCachedJuzDetail(juz);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }
  
  Future<void> saveLastRead(String surahName, int surahId, int ayahNumber) async {
    await local.saveLastRead(surahName, surahId, ayahNumber);
  }

  Future<Map<String, dynamic>?> getLastRead() {
    return local.getLastRead();
  }
}
