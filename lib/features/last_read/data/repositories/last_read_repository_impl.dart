import '../../domain/entities/last_read.dart';
import '../../domain/repositories/last_read_repository.dart';
import '../datasources/last_read_local_datasource.dart';
import '../models/last_read_model.dart';

class LastReadRepositoryImpl implements LastReadRepository {
  final LastReadLocalDataSource local;

  LastReadRepositoryImpl(this.local);

  @override
  Future<void> saveLastRead(LastRead data) {
    return local.saveHistory(
      LastReadModel(
        surahId: data.surahId,
        surahName: data.surahName,
        ayahNumber: data.ayahNumber,
        updatedAt: data.updatedAt,
      ),
    );
  }

  @override
  Future<List<LastRead>> getHistory() {
    return local.getHistory();
  }
}
