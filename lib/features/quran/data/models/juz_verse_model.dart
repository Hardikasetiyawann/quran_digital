import '../../domain/entities/juz_verse.dart';

class JuzVerseModel extends JuzVerse {
  const JuzVerseModel({
    required super.juz,
    required super.surahNumber,
    required super.surahName,
    required super.ayahNumber,
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
      'arab': arab,
      'translation': translation,
      'audio': audio,
    };
  }

  // Helper to convert from domain entity to model if needed (though we usually go Model -> Entity)
  factory JuzVerseModel.fromEntity(JuzVerse verse) {
    return JuzVerseModel(
      juz: verse.juz,
      surahNumber: verse.surahNumber,
      surahName: verse.surahName,
      ayahNumber: verse.ayahNumber,
      arab: verse.arab,
      translation: verse.translation,
      audio: verse.audio,
    );
  }
}
