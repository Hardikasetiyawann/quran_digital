class HomeMenu {
  final String title;
  final HomeMenuType type;

  const HomeMenu({
    required this.title,
    required this.type,
  });
}

enum HomeMenuType {
  quran,
  lastRead,
  search,
  prayer,
  settings,
}
