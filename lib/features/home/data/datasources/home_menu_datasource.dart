import '../../domain/entities/home_menu.dart';

abstract class HomeMenuDataSource {
  List<HomeMenu> getMenus();
}

class HomeMenuLocalDataSource implements HomeMenuDataSource {
  @override
  List<HomeMenu> getMenus() {
    return const [
      HomeMenu(title: 'BACA QURAN', type: HomeMenuType.quran),
      HomeMenu(title: 'TERAKHIR BACA', type: HomeMenuType.lastRead),
      HomeMenu(title: 'PENCARIAN', type: HomeMenuType.search),
      HomeMenu(title: 'JADWAL SHOLAT', type: HomeMenuType.prayer),
      HomeMenu(title: 'PENGATURAN', type: HomeMenuType.settings),
    ];
  }
}
