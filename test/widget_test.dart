import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:quran_digital/core/network/api_client.dart';
import 'package:quran_digital/features/quran/data/datasources/quran_local_datasource.dart';
import 'package:quran_digital/features/quran/data/datasources/quran_remote_datasource.dart';
import 'package:quran_digital/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:quran_digital/features/last_read/data/datasources/last_read_local_datasource.dart';
import 'package:quran_digital/features/last_read/data/repositories/last_read_repository_impl.dart';
import 'package:quran_digital/features/prayer/data/datasources/prayer_remote_datasource.dart';
import 'package:quran_digital/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:quran_digital/features/prayer/domain/usecases/get_prayer_times.dart';
import 'package:quran_digital/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Quran Digital smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    
    final apiClient = ApiClient(http.Client());
    final remote = QuranRemoteDataSourceImpl(apiClient);
    final local = QuranLocalDataSourceImpl(prefs);
    
    final prayerRemote = PrayerRemoteDataSourceImpl(apiClient);
    final prayerRepo = PrayerRepositoryImpl(prayerRemote);
    final getPrayerTimes = GetPrayerTimes(prayerRepo);
    
    final lastReadLocal = LastReadLocalDataSourceImpl(prefs);
    final lastReadRepo = LastReadRepositoryImpl(lastReadLocal);
    
    final repository = QuranRepositoryImpl(remote, local, lastReadRepo);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      quranRepo: repository,
      lastReadRepo: lastReadRepo,
      getPrayerTimes: getPrayerTimes,
    ));

    // Basic check to see if the app starts
    expect(find.text('Quran Digital'), findsWidgets);
  });
}
