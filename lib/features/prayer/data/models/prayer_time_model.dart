import '../../domain/entities/prayer_time.dart';

class PrayerTimeModel extends PrayerTime {
  const PrayerTimeModel({
    required super.name,
    required super.time,
  });

  factory PrayerTimeModel.fromJson(String name, String time) {
    return PrayerTimeModel(
      name: name,
      time: time.substring(0, 5), // HH:mm
    );
  }
}
