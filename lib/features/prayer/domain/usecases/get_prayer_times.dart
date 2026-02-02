import '../entities/prayer_time.dart';
import '../repositories/prayer_repository.dart';

class GetPrayerTimes {
  final PrayerRepository repository;
  GetPrayerTimes(this.repository);

  Future<List<PrayerTime>> call(double lat, double lon) {
    return repository.getTodayPrayerTimes(lat: lat, lon: lon);
  }
}
