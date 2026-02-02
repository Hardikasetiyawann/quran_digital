import 'package:equatable/equatable.dart';

abstract class LastReadEvent extends Equatable {
  const LastReadEvent();

  @override
  List<Object> get props => [];
}

class LoadLastReadHistory extends LastReadEvent {}
