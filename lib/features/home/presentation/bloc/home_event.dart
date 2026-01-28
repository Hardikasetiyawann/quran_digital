import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeMenus extends HomeEvent {}

class SelectHomeMenu extends HomeEvent {
  final int index;
  const SelectHomeMenu(this.index);

  @override
  List<Object?> get props => [index];
}
