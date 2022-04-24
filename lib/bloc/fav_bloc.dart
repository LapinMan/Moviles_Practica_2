import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musicapp/userAuthRepository.dart';

part 'fav_event.dart';
part 'fav_state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  FavBloc() : super(FavInitial()) {
    on<FavStartEvent>(fav_event);
  }

  FutureOr<void> fav_event(
      FavStartEvent event, Emitter<FavState> emitter) async {
    emit(FavLoadingState());

    try {
      var user = get_user();

      // Necesite ayuda en esta parte poque no sabia como diablos sacar la info
      Map<String, dynamic>? userData = (await user.get()).data();
      print("favlist data: $userData");
      List<dynamic> favList = userData!["FavList"];
      for (var i in favList) {
        if (i["title"] == event.data["title"] &&
            i["artist"] == event.data["artist"]) {
          print("Song already in list");
          emit(FavExistsState());
          return;
        }
      }
      // Song wasn't found in favs, add it
      favList = add_to_favs(favList, event.data);
      print("FavList to push: $favList");
      await user.update({"FavList": favList});

      // Success
      emit(FavSuccessState());
    } catch (e) {
      print("Error in favstart: $e");
      emit(FavErrState());
    }
  }

  List<dynamic> add_to_favs(List<dynamic> list, data) {
    list.add(data);
    return list;
  }

  DocumentReference<Map<String, dynamic>> get_user() {
    var user = FirebaseFirestore.instance
        .collection("userList")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return user;
  }
}
