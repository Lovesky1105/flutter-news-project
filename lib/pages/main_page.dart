import 'package:firebase_auth/firebase_auth.dart';
import 'package:fltproject_v3/pages/login_page.dart';
import 'package:fltproject_v3/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
        if(snapshot.hasData){
          return ProfileScreen();
        }else{
          return LoginScreen();
        }
        }
      ),
    );
  }
}
