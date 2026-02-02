import '../entities/last_read.dart';

abstract class LastReadRepository {
  Future<void> saveLastRead(LastRead data);
  Future<List<LastRead>> getHistory();
}
