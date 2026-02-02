import '../../domain/entities/last_read.dart';

class LastReadModel extends LastRead {
  const LastReadModel({
    required super.surahId,
    required super.surahName,
    required super.ayahNumber,
    required super.updatedAt,
  });

  factory LastReadModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['updatedAt']);
    } catch (_) {
      parsedDate = DateTime.now();
    }
    return LastReadModel(
      surahId: json['surahId'],
      surahName: json['surahName'],
      ayahNumber: json['ayahNumber'],
      updatedAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahId': surahId,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
