import '../../domain/entities/verse.dart';

class VerseModel extends Verse {
  const VerseModel({
    required super.number,
    required super.arab,
    required super.translation,
    required super.audio,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      number: json['number']['inSurah'],
      arab: json['text']['arab'],
      translation: json['translation']['id'],
      audio: json['audio']['primary'],
    );
  }
}
