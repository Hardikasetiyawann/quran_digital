import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/network/api_client.dart';
import 'core/utils/app_colors.dart';
import 'features/quran/domain/repositories/quran_repository.dart';
import 'features/quran/data/datasources/quran_local_datasource.dart';
import 'features/quran/data/datasources/quran_remote_datasource.dart';
import 'features/quran/data/repositories/quran_repository_impl.dart';
import 'features/quran/presentation/bloc/quran_bloc.dart';
import 'features/quran/presentation/bloc/quran_event.dart';
import 'features/home/data/datasources/home_menu_datasource.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/last_read/data/datasources/last_read_local_datasource.dart';
import 'features/last_read/data/repositories/last_read_repository_impl.dart';
import 'features/last_read/presentation/bloc/last_read_bloc.dart';
import 'features/last_read/presentation/bloc/last_read_event.dart';
import 'features/prayer/data/datasources/prayer_remote_datasource.dart';
import 'features/prayer/data/repositories/prayer_repository_impl.dart';
import 'features/prayer/domain/usecases/get_prayer_times.dart';
import 'features/prayer/presentation/bloc/prayer_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  // Dependencies
  final apiClient = ApiClient(http.Client());
  final quranRemote = QuranRemoteDataSourceImpl(apiClient);
  final quranLocal = QuranLocalDataSourceImpl(prefs);
  
  final lastReadLocal = LastReadLocalDataSourceImpl(prefs);
  final lastReadRepo = LastReadRepositoryImpl(lastReadLocal);
  
  final quranRepo = QuranRepositoryImpl(quranRemote, quranLocal, lastReadRepo);

  final prayerRemote = PrayerRemoteDataSourceImpl(apiClient);
  final prayerRepo = PrayerRepositoryImpl(prayerRemote);
  final getPrayerTimes = GetPrayerTimes(prayerRepo);

  runApp(MyApp(
    quranRepo: quranRepo,
    lastReadRepo: lastReadRepo,
    getPrayerTimes: getPrayerTimes,
  ));
}

class MyApp extends StatelessWidget {
  final QuranRepository quranRepo;
  final LastReadRepositoryImpl lastReadRepo;
  final GetPrayerTimes getPrayerTimes;
  const MyApp({
    super.key,
    required this.quranRepo,
    required this.lastReadRepo,
    required this.getPrayerTimes,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => QuranBloc(quranRepo)..add(LoadSurahList())..add(LoadLastRead()),
        ),
        BlocProvider(
          create: (_) => LastReadBloc(lastReadRepo)..add(LoadLastReadHistory()),
        ),
        BlocProvider(
          create: (_) => HomeBloc(HomeMenuLocalDataSource())..add(LoadHomeMenus()),
        ),
        BlocProvider(
          create: (_) => PrayerBloc(getPrayerTimes),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran Digital',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: Colors.white,
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(color: AppColors.textSecondary),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
