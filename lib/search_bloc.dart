import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_user_repository/search_user_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';

part 'search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchUserRepository searchUserRepository})
      : _searchUserRepository = searchUserRepository,
        super(SearchState()) {
    on<SearchUserEvent>(
      _onSearch,
      transformer: debounceDroppable(
        Duration(milliseconds: 500),
      ),
    );
  }

  late final SearchUserRepository _searchUserRepository;

  _onSearch(SearchUserEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) return emit(SearchState(users: []));
    if (event.query.length < 3) return;
    final users = await _searchUserRepository.onSearch(event.query);
    emit(SearchState(users: users));
  }
}
