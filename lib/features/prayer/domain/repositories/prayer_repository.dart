import '../entities/prayer_time.dart';

abstract class PrayerRepository {
  Future<List<PrayerTime>> getTodayPrayerTimes({
    required double lat,
    required double lon,
  });
}
