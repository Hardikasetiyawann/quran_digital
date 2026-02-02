import 'package:equatable/equatable.dart';
import '../../domain/entities/last_read.dart';

class LastReadState extends Equatable {
  final List<LastRead> history;
  final bool loading;

  const LastReadState({this.history = const [], this.loading = false});

  @override
  List<Object> get props => [history, loading];
}
