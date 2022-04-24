part of 'fav_bloc.dart';

@immutable
abstract class FavEvent extends Equatable {
  const FavEvent();

  @override
  List<Object> get props => [];
}

class FavStartEvent extends FavEvent {
  final Map<String, dynamic> data;

  FavStartEvent({required this.data});
  @override
  List<Object> get props => [this.data];
}

class FavAddEvent extends FavEvent {}
