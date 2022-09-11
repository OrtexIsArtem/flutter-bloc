part of 'search_bloc.dart';

class SearchEvent {}

class SearchUserEvent extends SearchEvent {
  final String query;

  SearchUserEvent(this.query);
}
