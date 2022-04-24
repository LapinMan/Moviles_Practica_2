part of 'favlist_bloc.dart';

abstract class FavlistEvent extends Equatable {
  const FavlistEvent();

  @override
  List<Object> get props => [];
}

class FavlistTriggerEvent extends FavlistEvent {}

class FavlistRemoveEvent extends FavlistEvent {
  final int index;

  FavlistRemoveEvent({required this.index});
  @override
  List<Object> get props => [this.index];
}
