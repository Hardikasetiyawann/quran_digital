import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/usecases/get_prayer_times.dart';

abstract class PrayerEvent {}
class LoadPrayerTimes extends PrayerEvent {
  final double lat;
  final double lon;
  LoadPrayerTimes(this.lat, this.lon);
}

class PrayerState {
  final List<PrayerTime> times;
  final bool loading;

  const PrayerState({
    this.times = const [],
    this.loading = false,
  });
}

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final GetPrayerTimes getPrayerTimes;

  PrayerBloc(this.getPrayerTimes) : super(const PrayerState()) {
    on<LoadPrayerTimes>((event, emit) async {
      emit(const PrayerState(loading: true));
      final data = await getPrayerTimes(event.lat, event.lon);
      emit(PrayerState(times: data));
    });
  }
}
