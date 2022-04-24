import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:musicapp/homepage/homepage.dart';

import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoginSuccessState) {
          return HomePage();
        } else {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 180,
                                width: 180,
                                child: Image.asset("assets/music.png")),
                            ElevatedButton.icon(
                              onPressed: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(GoogleLoginEvent());
                              },
                              icon: Icon(Icons.donut_large),
                              label: Text("Sign In con Google"),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            GoogleSignInButton(
                              clientId: '',
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage("assets/plasma-ball.gif"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.dstATop)),
              ),
            ),
          );
        }
      },
    );
  }
}
