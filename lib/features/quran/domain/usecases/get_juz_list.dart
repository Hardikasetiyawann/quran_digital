import '../repositories/quran_repository.dart';

class GetJuzList {
  final QuranRepository repository;

  GetJuzList(this.repository);

  /// Mengembalikan list Juz [1..30]
  Future<List<int>> call() {
    return repository.getJuzList();
  }
}
