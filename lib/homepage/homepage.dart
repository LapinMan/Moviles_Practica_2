import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/favlist/favlist.dart';
import 'package:musicapp/foundMusic/showmusic.dart';
import 'package:musicapp/homepage/bloc/musicbutton_bloc.dart';
import 'package:musicapp/login/login.dart';

import '../bloc/login_bloc.dart';
import '../favlist/bloc/favlist_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: BlocListener<MusicbuttonBloc, MusicbuttonState>(
        listener: (context, state) {
          if (state is MusicbuttonFoundState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShowMusic(
                  music_data: {
                    "_album": state.data[0],
                    "_title": state.data[1],
                    "_artist": state.data[2],
                    "_release_date": state.data[3],
                    "_cover_url": state.data[4],
                    "_spotify_link": state.data[5],
                    "_apple_link": state.data[6],
                    "_deez_link": state.data[7]
                  },
                ),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocConsumer<MusicbuttonBloc, MusicbuttonState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is MusicbuttonListeningState) {
                  return Text(
                    "Escuchando...",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                        decoration: TextDecoration.none),
                  );
                } else {
                  return Text(
                    "Haz Click en el boton",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                        decoration: TextDecoration.none),
                  );
                }
              },
            ),
            _button_body(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 75,
                  width: 75,
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                FavlistBloc()..add(FavlistTriggerEvent()),
                            child: FavoriteList(),
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                    shape: new CircleBorder(),
                  ),
                ),
                Container(
                  height: 75,
                  width: 75,
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LogOutSucessState) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return RawMaterialButton(
                        fillColor: Colors.white,
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(SignOutLoginEvent());
                        },
                        child: Icon(
                          Icons.power_settings_new,
                          color: Colors.black,
                        ),
                        shape: new CircleBorder(),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  BlocConsumer<MusicbuttonBloc, MusicbuttonState> _button_body() {
    return BlocConsumer<MusicbuttonBloc, MusicbuttonState>(
        builder: (context, state) {
          try {
            if (state is MusicbuttonListeningState) {
              return _listening_music_button();
            } else {
              return _idle_music_button();
            }
          } catch (e) {
            return _idle_music_button();
          }
        },
        listener: (context, state) {});
  }

  Container _idle_music_button() {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: AvatarGlow(
        endRadius: 200.0,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 1000),
        repeatPauseDuration: Duration(milliseconds: 500),
        repeat: true,
        showTwoGlows: true,
        animate: false,
        child: Container(
          width: 200.0,
          height: 200.0,
          child: new RawMaterialButton(
            fillColor: Colors.white,
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(37.0),
              child: Image.asset("assets/music.png"),
            ),
            onPressed: () {
              BlocProvider.of<MusicbuttonBloc>(context).add(MusicUpdateEvent());
            },
          ),
        ),
      ),
    );
  }

  Container _listening_music_button() {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: AvatarGlow(
        endRadius: 200.0,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 1000),
        repeatPauseDuration: Duration(milliseconds: 500),
        repeat: true,
        showTwoGlows: true,
        animate: true,
        child: Container(
          width: 200.0,
          height: 200.0,
          child: new RawMaterialButton(
            fillColor: Colors.white,
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(37.0),
              child: Image.asset("assets/music.png"),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
