import '../entities/verse.dart';
import '../repositories/quran_repository.dart';

class GetSurahDetail {
  final QuranRepository repository;
  GetSurahDetail(this.repository);

  Future<List<Verse>> call(int surahId) {
    return repository.getSurahDetail(surahId);
  }
}
