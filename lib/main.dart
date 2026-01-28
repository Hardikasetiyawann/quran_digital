import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/data/datasources/home_menu_datasource.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/app_colors.dart';
import 'features/quran/data/datasources/quran_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Digital',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) {
           final apiClient = ApiClient(http.Client());
           final remote = QuranRemoteDataSourceImpl(apiClient);
           final local = QuranLocalDataSourceImpl(prefs);
           final repository = QuranRepositoryImpl(remote, local);

           return QuranBloc(
              GetSurahList(repository),
              GetSurahDetail(repository),
              GetJuzList(repository),
              GetJuzDetail(repository),
              repository, // Pass repository directly for Last Read
           )..add(LoadSurahList())..add(LoadLastRead()); // Trigger LoadLastRead
        },
        child: const QuranHomePage(), 
      ),
    );
  }
}
