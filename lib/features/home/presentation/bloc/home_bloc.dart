import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/home_menu_datasource.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeMenuDataSource dataSource;

  HomeBloc(this.dataSource) : super(HomeInitial()) {
    on<LoadHomeMenus>((event, emit) {
      final menus = dataSource.getMenus();
      emit(HomeLoaded(menus));
    });
  }
}
