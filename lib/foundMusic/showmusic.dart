import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../bloc/fav_bloc.dart';

class ShowMusic extends StatefulWidget {
  final music_data;

  ShowMusic({Key? key, required this.music_data}) : super(key: key);

  @override
  State<ShowMusic> createState() => _ShowMusicState();
}

class _ShowMusicState extends State<ShowMusic> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.music_data["_title"]}"),
        actions: [
          BlocConsumer<FavBloc, FavState>(
            listener: (context, state) {
              if (state is FavLoadingState) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Adding to favorites..."),
                  ));
              } else if (state is FavSuccessState) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Song was added to favorites"),
                  ));
              } else if (state is FavExistsState) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Song already in favorites"),
                  ));
              } else {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(
                        "Something happened, could not add to favorites list"),
                  ));
              }
            },
            builder: (context, state) {
              if (state is FavLoadingState) {
                return favBlocked();
              } else {
                return favAvailable();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            cover_art(widget.music_data["_cover_url"]),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    "${widget.music_data["_title"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "${widget.music_data["_album"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "${widget.music_data["_artist"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "${widget.music_data["_release_date"]}",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        decoration: TextDecoration.none),
                  )
                ],
              ),
            ),
            Divider(),
            Column(
              children: [
                Text(
                  "Abrir con:",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      decoration: TextDecoration.none),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: RawMaterialButton(
                            fillColor: Colors.white,
                            shape: new CircleBorder(),
                            onPressed: () {
                              _launchUrl(
                                  "${widget.music_data["_spotify_link"]}");
                            },
                            child: Image.asset("assets/spotify.png")),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: RawMaterialButton(
                            fillColor: Colors.white,
                            shape: new CircleBorder(),
                            onPressed: () {
                              _launchUrl("${widget.music_data["_deez_link"]}");
                            },
                            child: Text("Deezer")),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: RawMaterialButton(
                            fillColor: Colors.white,
                            shape: new CircleBorder(),
                            onPressed: () {
                              _launchUrl("${widget.music_data["_apple_link"]}");
                            },
                            child: Image.asset("assets/apple.png")),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  IconButton favAvailable() {
    return IconButton(
        onPressed: () {
          BlocProvider.of<FavBloc>(context).add(FavStartEvent(data: {
            "title": widget.music_data["_title"],
            "artist": widget.music_data["_artist"],
            "album": widget.music_data["_album"],
            "release_date": widget.music_data["_release_date"],
            "url": widget.music_data["_cover_url"]
          }));
        },
        icon: Icon(
          Icons.favorite,
          color: Colors.white,
        ));
  }

  IconButton favBlocked() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.favorite,
        color: Colors.grey,
      ),
    );
  }

  Container cover_art(String data) {
    if (data == "Cover art not found") {
      return cover_asset();
    } else
      return cover_url(data);
  }

  Container cover_asset() {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/default_album.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container cover_url(String url) {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _launchUrl(url) async {
    if (!await ul.launch(url)) throw "Could not launch $url";
  }
}
