import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/favlist/bloc/favlist_bloc.dart';

class FavoriteList extends StatefulWidget {
  FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  int selectedSlot = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
        ),
        body: BlocConsumer<FavlistBloc, FavlistState>(
            builder: (context, state) {
              if (state is FavlistSucessState) {
                return generate_list(state.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            listener: (context, state) {}));
  }

  ListView generate_list(List<dynamic> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    cover_art(data[index]["url"]),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            selectedSlot = index;
                          });
                          showDialog(context: context, builder: remove_fav);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 40,
                        ))
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          data[index]["title"],
                          style: TextStyle(fontSize: 26),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          data[index]["album"],
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        Text(
                          data[index]["artist"],
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  AspectRatio cover_art(String data) {
    if (data == "Cover art not found") {
      return cover_asset();
    } else
      return cover_url(data);
  }

  AspectRatio cover_asset() {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.asset(
        "assets/default_album.png",
        fit: BoxFit.cover,
      ),
    );
  }

  AspectRatio cover_url(String url) {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }

  AlertDialog remove_fav(data) {
    return AlertDialog(
      title: Text("Remove song!"),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('You are about to remove AAAAAAAA from your favourites list'),
            Text('Would you like to proceed?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Proceed'),
          onPressed: () {
            BlocProvider.of<FavlistBloc>(context)
                .add(FavlistRemoveEvent(index: selectedSlot));
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
