import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/juz_verse.dart';
import '../models/surah_model.dart';
import '../models/juz_verse_model.dart';

abstract class QuranLocalDataSource {
  Future<void> cacheSurahList(List<SurahModel> list);
  Future<List<SurahModel>> getCachedSurahList();
  
  Future<void> cacheJuzDetail(int juz, List<JuzVerseModel> list);
  Future<List<JuzVerseModel>> getCachedJuzDetail(int juz);

  Future<void> saveLastRead(String surahName, int surahId, int ayahNumber);
  Future<Map<String, dynamic>?> getLastRead();
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final SharedPreferences sharedPreferences;

  QuranLocalDataSourceImpl(this.sharedPreferences);

  static const String cachedSurahListKey = 'CACHED_SURAH_LIST';
  static const String cachedJuzPrefix = 'CACHED_JUZ_';
  static const String cachedLastReadKey = 'CACHED_LAST_READ';

  @override
  Future<void> cacheSurahList(List<SurahModel> list) async {
    final jsonList = list.map((e) => e.toJson()).toList();
    await sharedPreferences.setString(cachedSurahListKey, json.encode(jsonList));
  }

  @override
  Future<List<SurahModel>> getCachedSurahList() async {
    final jsonString = sharedPreferences.getString(cachedSurahListKey);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((e) => SurahModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheJuzDetail(int juz, List<JuzVerseModel> list) async {
    final jsonList = list.map((e) => e.toJson()).toList();
    await sharedPreferences.setString('$cachedJuzPrefix$juz', json.encode(jsonList));
  }

  @override
  Future<List<JuzVerseModel>> getCachedJuzDetail(int juz) async {
    final jsonString = sharedPreferences.getString('$cachedJuzPrefix$juz');
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((e) => JuzVerseModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> saveLastRead(String surahName, int surahId, int ayahNumber) async {
    final data = {
      'surahName': surahName,
      'surahId': surahId,
      'ayahNumber': ayahNumber,
    };
    await sharedPreferences.setString(cachedLastReadKey, json.encode(data));
  }

  @override
  Future<Map<String, dynamic>?> getLastRead() async {
    final jsonString = sharedPreferences.getString(cachedLastReadKey);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
}
