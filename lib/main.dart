import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/bloc/login_bloc.dart';
import 'package:musicapp/favlist/bloc/favlist_bloc.dart';
import 'package:musicapp/homepage/bloc/musicbutton_bloc.dart';
import 'package:musicapp/login/login.dart';

import 'bloc/fav_bloc.dart';
import 'homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await SpotifySdk.connectToSpotifyRemote(clientId: "", redirectUrl: "");

  // No esta optimizado, pero no tengo tiempo para optimizar
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => LoginBloc()..add(VerifyLoginEvent())),
      BlocProvider(create: (context) => MusicbuttonBloc()),
      BlocProvider(create: (context) => FavBloc())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(brightness: Brightness.dark),
      home: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginErrState) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No se ha podido autenticar")));
          }
        },
        builder: (context, state) {
          if (state is LoginSuccessState) {
            return HomePage();
          } else if (state is LogOutSucessState || state is LoginErrState) {
            return BlocProvider(
              create: (context) => MusicbuttonBloc(),
              child: LoginPage(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
