import '../../domain/entities/juz_verse.dart';

class JuzVerseModel extends JuzVerse {
  const JuzVerseModel({
    required super.juz,
    required super.surahNumber,
    required super.surahName,
    required super.ayahNumber,
    required super.inQuran,
    required super.arab,
    required super.translation,
    required super.audio,
  });

  factory JuzVerseModel.fromJson(Map<String, dynamic> json) {
    return JuzVerseModel(
      juz: json['juz'] as int,
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      ayahNumber: json['ayahNumber'] as int,
      inQuran: json['inQuran'] as int? ?? 0,
      arab: json['arab'] as String,
      translation: json['translation'] as String,
      audio: json['audio'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'juz': juz,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'inQuran': inQuran,
      'arab': arab,
      'translation': translation,
      'audio': audio,
    };
  }

  factory JuzVerseModel.fromEntity(JuzVerse verse) {
    return JuzVerseModel(
      juz: verse.juz,
      surahNumber: verse.surahNumber,
      surahName: verse.surahName,
      ayahNumber: verse.ayahNumber,
      inQuran: verse.inQuran,
      arab: verse.arab,
      translation: verse.translation,
      audio: verse.audio,
    );
  }
}
