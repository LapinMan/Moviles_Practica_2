import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicapp/bloc/fav_bloc.dart';

part 'favlist_event.dart';
part 'favlist_state.dart';

class FavlistBloc extends Bloc<FavlistEvent, FavlistState> {
  FavlistBloc() : super(FavlistInitial()) {
    on<FavlistTriggerEvent>(init_list);
    on<FavlistRemoveEvent>(remove_from_favs);
  }

  FutureOr<void> init_list(
      FavlistTriggerEvent event, Emitter<FavlistState> emitter) async {
    print("Attempting to init list");
    emit(FavlistInitial());
    try {
      // Fetch User
      var user = get_user();
      // Fetch Collection
      Map<String, dynamic>? userData = (await user.get()).data();
      // Fetch Data
      List<dynamic> favList = userData!["FavList"];
      emit(FavlistSucessState(data: favList));
    } catch (e) {
      print("error at loading list $e");
      emit(FavlistFailState());
    }
  }

  FutureOr<void> remove_from_favs(
      FavlistRemoveEvent event, Emitter<FavlistState> emitter) async {
    print("Attempting to remove from favorites");
    emit(FavlistInitial());
    try {
      // Get user
      var user = get_user();
      // Get collection
      Map<String, dynamic>? userData = (await user.get()).data();
      // Get list
      List<dynamic> favList = userData!["FavList"];
      // modify list
      print("4");
      favList.removeAt(event.index);
      print("5");
      await user.update({"FavList": favList});
      // END
      print("6");
      emit(FavlistInitial());
      // Update list
      await init_list(FavlistTriggerEvent(), emitter);
    } catch (e) {
      print("Error at removing from favs: $e");
      emit(FavlistFailState());
    }
  }

  DocumentReference<Map<String, dynamic>> get_user() {
    var user = FirebaseFirestore.instance
        .collection("userList")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return user;
  }
}
