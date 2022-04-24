part of 'fav_bloc.dart';

abstract class FavState extends Equatable {
  const FavState();

  @override
  List<Object> get props => [];
}

class FavInitial extends FavState {}

class FavLoadingState extends FavState {}

class FavErrState extends FavState {}

class FavExistsState extends FavState {}

class FavNoExistsState extends FavState {}

class FavSuccessState extends FavState {}
