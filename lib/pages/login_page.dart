import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fltproject_v3/pages/profile_page.dart';
import 'package:fltproject_v3/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<FirebaseApp> _initializaFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        future: _initializaFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){

            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  //Login function
  static Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,}) async{
    FirebaseAuth auth  =FirebaseAuth.instance;
    User ? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        print("no user found for thaty email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    Future<void>_sharePref() async{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email=prefs.getString(_emailController.toString());
      print(email);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            const Text("New News",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),),
            const Text("Login to your apps",
              style: TextStyle(
                color: Colors.black,
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "User email:",
                prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black),
              ),
            ),

            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "User Password:",
                prefixIcon: Icon(
                    Icons.security,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 88.0,
            ),

            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0xFF0069FE),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0 ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0 )
                ),
                onPressed: () async{
                  User? user = await loginUsingEmailPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      context: context);
                  print(user);
                  if(user != null){
                    _sharePref();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen()));
                  }
                },
                child: const Text("Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ),
            ),
            Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  RegisterPage()),
                      );
                    },
                  ),
                ]
            ),
          ],
        ),
      ),
      ),
    );
  }
}


