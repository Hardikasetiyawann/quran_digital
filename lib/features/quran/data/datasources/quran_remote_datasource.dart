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

      // Safe parsing to prevent "Null is not a subtype of Map"
      final number = v['number'];
      final surah = v['surah'];

      // Default values or skip if critical data is missing
      // (Here we use default values to keep the UI showing something rather than crashing)
      final surahMap = surah is Map<String, dynamic> ? surah : <String, dynamic>{};
      final numberMap = number is Map<String, dynamic> ? number : <String, dynamic>{};

      final surahNameMap = surahMap['name'] is Map<String, dynamic> ? surahMap['name'] : <String, dynamic>{};
      final transliterationMap = surahNameMap['transliteration'] is Map<String, dynamic> ? surahNameMap['transliteration'] : <String, dynamic>{};
      
      final surahName = (transliterationMap['id'] as String?) ?? 'Unknown Surah';
      
      final textMap = v['text'] is Map<String, dynamic> ? v['text'] : <String, dynamic>{};
      final translationMap = v['translation'] is Map<String, dynamic> ? v['translation'] : <String, dynamic>{};
      final audioMap = v['audio'] is Map<String, dynamic> ? v['audio'] : <String, dynamic>{};

      return JuzVerse(
        juz: juz,
        ayahNumber: (numberMap['inSurah'] as int?) ?? 0,
        surahNumber: (surahMap['number'] as int?) ?? 0,
        surahName: surahName,
        arab: (textMap['arab'] as String?) ?? '',
        translation: (translationMap['id'] as String?) ?? '',
        audio: (audioMap['primary'] as String?) ?? '',
      );
    }).toList();
  }
}
