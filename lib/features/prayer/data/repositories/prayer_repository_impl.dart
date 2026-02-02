import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_remote_datasource.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerRemoteDataSource remote;

  PrayerRepositoryImpl(this.remote);

  @override
  Future<List<PrayerTime>> getTodayPrayerTimes({
    required double lat,
    required double lon,
  }) {
    return remote.getTodayPrayerTimes(lat: lat, lon: lon);
  }
}
