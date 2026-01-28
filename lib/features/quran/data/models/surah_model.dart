import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.name,
    required super.latin,
    required super.verses,
    required super.meaning,
    required super.revelation,
  });

  factory SurahModel.fromSurahApi(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'],
      name: json['name']['short'],
      latin: json['name']['transliteration']['id'],
      verses: json['numberOfVerses'],
      meaning: json['name']['translation']['id'],
      revelation: json['revelation']['id'] == 'meccan' ? 'Mekah' : 'Madinah',
    );
  }

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'],
      name: json['name'],
      latin: json['latin'],
      verses: json['verses'],
      meaning: json['meaning'],
      revelation: json['revelation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'latin': latin,
      'verses': verses,
      'meaning': meaning,
      'revelation': revelation,
    };
  }
}
