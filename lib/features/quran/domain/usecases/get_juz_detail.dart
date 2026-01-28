import '../entities/juz_verse.dart';
import '../repositories/quran_repository.dart';

class GetJuzDetail {
  final QuranRepository repository;

  GetJuzDetail(this.repository);

  Future<List<JuzVerse>> call(int juz) {
    return repository.getJuzDetail(juz);
  }
}
