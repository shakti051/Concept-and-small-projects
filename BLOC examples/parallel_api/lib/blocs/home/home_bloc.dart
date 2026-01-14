import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../service/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final (posts, users) = await repository.fetchHomeData();
      emit(HomeLoaded(posts, users));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
