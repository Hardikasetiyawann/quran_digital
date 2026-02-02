import '../../../../core/network/api_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/surah_model.dart';
import '../models/verse_model.dart';
import '../../domain/entities/juz_verse.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getSurahList();
  Future<List<VerseModel>> getSurahDetail(int id);
  Future<List<JuzVerse>> getJuzDetail(int juz);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  final ApiClient client;
  QuranRemoteDataSourceImpl(this.client);

  @override
  Future<List<SurahModel>> getSurahList() async {
    final res = await client.get('${AppConstants.baseUrl}/surah');
    return (res['data'] as List)
        .map((e) => SurahModel.fromSurahApi(e))
        .toList();
  }

  @override
  Future<List<VerseModel>> getSurahDetail(int id) async {
    final res = await client.get('${AppConstants.baseUrl}/surah/$id');
    return (res['data']['verses'] as List)
        .map((e) => VerseModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<JuzVerse>> getJuzDetail(int juz) async {
    final res = await client.get('${AppConstants.baseUrl}/juz/$juz');

    final rawVerses = res['data']?['verses'];
    if (rawVerses == null || rawVerses is! List) {
      throw Exception('Data juz $juz tidak valid');
    }

    return rawVerses.map<JuzVerse>((raw) {
      final v = raw as Map<String, dynamic>;

      final number = v['number'] as Map<String, dynamic>? ?? {};
      final surahRaw = v['surah'];
      
      Map<String, dynamic> surahMap = {};
      int surahNumber = 0;
      String surahName = 'Unknown Surah';

      if (surahRaw is Map<String, dynamic>) {
        surahMap = surahRaw;
        surahNumber = surahMap['number'] as int? ?? 0;
        
        final surahNameMap = surahMap['name'] as Map<String, dynamic>? ?? {};
        final transliterationMap = surahNameMap['transliteration'] as Map<String, dynamic>? ?? {};
        surahName = (transliterationMap['id'] as String?) ?? (transliterationMap['en'] as String?) ?? 'Unknown Surah';
      } else if (surahRaw is int) {
        surahNumber = surahRaw;
      }

      final textMap = v['text'] as Map<String, dynamic>? ?? {};
      final translationMap = v['translation'] as Map<String, dynamic>? ?? {};
      final audioMap = v['audio'] as Map<String, dynamic>? ?? {};

      return JuzVerse(
        juz: juz,
        ayahNumber: (number['inSurah'] as int?) ?? 0,
        inQuran: (number['inQuran'] as int?) ?? 0,
        surahNumber: surahNumber,
        surahName: surahName,
        arab: (textMap['arab'] as String?) ?? '',
        translation: (translationMap['id'] as String?) ?? '',
        audio: (audioMap['primary'] as String?) ?? '',
      );
    }).toList();
  }
}
