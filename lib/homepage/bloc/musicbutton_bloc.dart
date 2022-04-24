import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../util/secrets.dart';

part 'musicbutton_event.dart';
part 'musicbutton_state.dart';

class MusicbuttonBloc extends Bloc<MusicbuttonEvent, MusicbuttonState> {
  MusicbuttonBloc() : super(MusicbuttonInitial()) {
    on<MusicbuttonEvent>(_listen_to_music);
  }

  FutureOr<void> _listen_to_music(event, emitter) async {
    emit(MusicbuttonListeningState());
    try {
      print("Trying to send music to API");
      String? recording_path = await get_recording();
      if (recording_path == null) {
        print("Received nothing on get_recording()");
        emit(MusicbuttonErrState());
        return;
      }
      // Get file to convert
      print("The path of the file is: $recording_path");
      final File file = File('${recording_path}');
      // Get converted File
      String b64 = await file_to_b64(file);
      // Attempt to send info
      var response = await recognize_audio(b64);
      if (response == null) {
        return null;
        emit(MusicbuttonErrState());
      }
      var jsonresponse = jsonDecode(response) as Map;
      if (jsonresponse["result"] == null) {
        print("Got Nothing");
        emit(MusicbuttonNotFoundState());
        return null;
      }
      //Success
      jsonresponse = jsonresponse["result"];
      print("Data found $jsonresponse");
      List<String> finaldata = [];
      // I APOLOGIZE FOR THIS HORRIFIC THING, I DON'T HAVE TIME TO MAKE IT CLEANER BECAUSE DEADLINE IS TODAY
      if (jsonresponse.containsKey("artist")) {
        finaldata.add(jsonresponse["artist"]);
      } else {
        finaldata.add("Artist not found");
      }
      if (jsonresponse.containsKey("title")) {
        finaldata.add(jsonresponse["title"]);
      } else {
        finaldata.add("Title not found");
      }
      if (jsonresponse.containsKey("album")) {
        finaldata.add(jsonresponse["album"]);
      } else {
        finaldata.add("Album not found");
      }
      if (jsonresponse.containsKey("release_date")) {
        finaldata.add(jsonresponse["release_date"]);
      } else {
        finaldata.add("Release Date not found");
      }
      if (jsonresponse.containsKey("spotify")) {
        finaldata.add(jsonresponse["spotify"]["album"]["images"][0]["url"]);
        finaldata.add(jsonresponse["spotify"]["external_urls"]["spotify"]);
      } else {
        finaldata.add("Spotify not found");
        finaldata.add("Spotify not found");
      }
      if (jsonresponse.containsKey("apple_music")) {
        finaldata.add(jsonresponse["apple_music"]["url"]);
      } else {
        finaldata.add("Apple not found");
      }
      if (jsonresponse.containsKey("deezer")) {
        finaldata.add(jsonresponse["deezer"]["link"]);
      } else {
        finaldata.add("Deezer not found");
      }
      print("Data to emit: $finaldata");
      emit(
        MusicbuttonFoundState(data: finaldata),
      );
    } catch (e) {
      print("Error at Music Bloc $e");
      emit(MusicbuttonErrState());
    }
  }

  Future<String> _get_temp_path() async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<String?> get_recording() async {
    // Init Variables

    final record = Record();
    try {
      // Get permission
      bool got_permission = await record.hasPermission();
      print("Got Permission? $got_permission");

      // Check and request permission
      if (!got_permission) {
        print("Did not get permission: $got_permission");
        return null;
      }

      String temp_path = await _get_temp_path();
      final String file_name = "recording.m4a";

      // Start recording
      await record.start(
        path: '${temp_path}/${file_name}', // required
        encoder: AudioEncoder.AAC, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );

      // Stop recording after 6 seconds
      await Future.delayed(Duration(seconds: 7));
      return await record.stop();
    } catch (e) {
      print("ERR on get_recording(): $e");
      return null;
    }
  }

  Future<String> file_to_b64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64String = base64Encode(fileBytes);
    String optional = "data:audio/m4a;base64,";
    return '$base64String';
  }

  Future<String?> recognize_audio(String b64) async {
    String url = "https://api.audd.io/";
    Map<String, dynamic> data = {
      "api_token": "${API_KEY}",
      "audio": b64,
      "method": "recognize",
      "return": 'apple_music,spotify,deezer',
    };

    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'multipart/form-data',
          },
          body: jsonEncode(data));
      return response.body;
    } catch (e) {
      return null;
    }
  }
}
