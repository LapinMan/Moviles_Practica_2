part of 'musicbutton_bloc.dart';

@immutable
abstract class MusicbuttonEvent extends Equatable {
  const MusicbuttonEvent();

  @override
  List<Object> get props => [];
}

class MusicUpdateEvent extends MusicbuttonEvent {}
