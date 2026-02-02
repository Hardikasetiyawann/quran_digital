import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/last_read_model.dart';

abstract class LastReadLocalDataSource {
  Future<void> saveHistory(LastReadModel data);
  Future<List<LastReadModel>> getHistory();
}

class LastReadLocalDataSourceImpl implements LastReadLocalDataSource {
  final SharedPreferences prefs;
  LastReadLocalDataSourceImpl(this.prefs);

  static const _key = 'LAST_READ_HISTORY';
  static const _lastResetKey = 'LAST_READ_RESET_DATE';

  @override
  Future<void> saveHistory(LastReadModel data) async {
    await _checkAndResetMonthly();
    final list = await getHistory();

    // remove same surah (update instead)
    list.removeWhere((e) => e.surahId == data.surahId);

    list.insert(0, data); // newest on top

    final jsonList = list.map((e) => e.toJson()).toList();
    await prefs.setString(_key, json.encode(jsonList));
  }

  @override
  Future<List<LastReadModel>> getHistory() async {
    await _checkAndResetMonthly();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    try {
      final List decoded = json.decode(jsonString);
      return decoded.map((e) => LastReadModel.fromJson(e)).toList();
    } catch (e) {
      // If decoding fails, return empty but keep the key for now 
      // Or clear it if it's truly corrupted
      return [];
    }
  }

  Future<void> _checkAndResetMonthly() async {
    final now = DateTime.now();
    final lastResetString = prefs.getString(_lastResetKey);

    if (lastResetString == null) {
      // First time initialization
      await prefs.setString(_lastResetKey, now.toIso8601String());
      return;
    }

    final lastReset = DateTime.parse(lastResetString);
    
    // If year or month is different, it means we entered a new month (or year)
    if (now.year != lastReset.year || now.month != lastReset.month) {
      await prefs.remove(_key);
      await prefs.setString(_lastResetKey, now.toIso8601String());
    }
  }
}
