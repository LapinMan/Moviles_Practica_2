part of 'musicbutton_bloc.dart';

abstract class MusicbuttonState extends Equatable {
  const MusicbuttonState();

  @override
  List<Object> get props => [];
}

class MusicbuttonInitial extends MusicbuttonState {}

class MusicbuttonWaitingState extends MusicbuttonState {}

class MusicbuttonListeningState extends MusicbuttonState {}

class MusicbuttonNotFoundState extends MusicbuttonState {}

class MusicbuttonFoundState extends MusicbuttonState {
  final List<Object> data;

  MusicbuttonFoundState({required this.data});
  @override
  List<Object> get props => [data];
}

class MusicbuttonErrState extends MusicbuttonState {}
