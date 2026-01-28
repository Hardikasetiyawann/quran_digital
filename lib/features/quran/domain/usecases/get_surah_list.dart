import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

class GetSurahList {
  final QuranRepository repository;
  GetSurahList(this.repository);

  Future<List<Surah>> call() => repository.getSurahList();
}
