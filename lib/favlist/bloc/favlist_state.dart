part of 'favlist_bloc.dart';

abstract class FavlistState extends Equatable {
  const FavlistState();

  @override
  List<Object> get props => [];
}

class FavlistInitial extends FavlistState {}

class FavlistSucessState extends FavlistState {
  final List<dynamic> data;

  FavlistSucessState({required this.data});
  @override
  List<Object> get props => [data];
}

class FavlistFailState extends FavlistState {}
