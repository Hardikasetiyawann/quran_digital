import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/last_read_repository.dart';
import 'last_read_event.dart';
import 'last_read_state.dart';

class LastReadBloc extends Bloc<LastReadEvent, LastReadState> {
  final LastReadRepository repository;

  LastReadBloc(this.repository) : super(const LastReadState()) {
    on<LoadLastReadHistory>((_, emit) async {
      emit(LastReadState(history: state.history, loading: true));
      final data = await repository.getHistory();
      emit(LastReadState(history: data, loading: false));
    });
  }
}
