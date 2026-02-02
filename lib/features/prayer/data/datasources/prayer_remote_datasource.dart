import '../../../../core/network/api_client.dart';
import '../models/prayer_time_model.dart';

abstract class PrayerRemoteDataSource {
  Future<List<PrayerTimeModel>> getTodayPrayerTimes({
    required double lat,
    required double lon,
  });
}

class PrayerRemoteDataSourceImpl implements PrayerRemoteDataSource {
  final ApiClient client;
  PrayerRemoteDataSourceImpl(this.client);

  @override
  Future<List<PrayerTimeModel>> getTodayPrayerTimes({
    required double lat,
    required double lon,
  }) async {
    final url =
        'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=2';

    final res = await client.get(url);
    final timings = res['data']['timings'];

    return [
      PrayerTimeModel.fromJson('Subuh', timings['Fajr']),
      PrayerTimeModel.fromJson('Dzuhur', timings['Dhuhr']),
      PrayerTimeModel.fromJson('Ashar', timings['Asr']),
      PrayerTimeModel.fromJson('Maghrib', timings['Maghrib']),
      PrayerTimeModel.fromJson('Isya', timings['Isha']),
    ];
  }
}
