import 'package:equatable/equatable.dart';
import '../../domain/entities/home_menu.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final List<HomeMenu> menus;

  const HomeLoaded(this.menus);

  @override
  List<Object?> get props => [menus];
}
