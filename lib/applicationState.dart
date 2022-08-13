import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // new
import 'package:student_shopping_v1/pages/verifyEmail.dart';
import 'Authentication/authentication.dart'; // new
import 'Widgets/appbar.dart';
import 'widgets.dart';
import 'buyerhome.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot){
        return MaterialApp(
            title: 'Student Shop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(

                primary: Colors.grey[300],
              // secondary: Colors.grey.shade700,

              // or from RGB

              ),
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.grey[200],
              ),
          // textTheme: GoogleFonts.robotoTextTheme(
            //   Theme.of(context).textTheme,
            // ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: snapshot.hasData && snapshot.data != null ? BuyerHomePage("Student Shop") : HomePage(),
          initialRoute: snapshot.hasData && snapshot.data != null ? '/buyerhome' : '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/' : (context) =>  HomePage(),
            '/buyerhome': (context) =>  BuyerHomePage('Buyer Home Page'),
            '/verifyEmailPage': (context) =>  VerifyScreen(),

            // When navigating to the "/second" route, build the SecondScreen widget.
            // '/second': (context) => const SecondScreen(),
          },
        );
      },

    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This size provide us total height and width of our screen

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Container(
            // margin: EdgeInsets.only(right: 10),
            // child: Icon(
            //   Icons.search,
            //   color: Colors.grey[800],
            //   size: 27,
            // ),
          ),
        ),
        iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
        backgroundColor: Colors.grey[300],
        elevation: .1,
        title: Center(
          child: Text(
            'Student Shopping',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.notifications,
              color: Colors.grey[800],
              size: 27,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/images/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          // to here
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("Trusted people buying and selling to each other"),
          const Paragraph(
            'Sign in for an experience created just for you',
          ),
          // HomePage("Student Shop"),
        ],
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        if (user.emailVerified != true)
          _loginState = ApplicationLoginState.unVerifiedEmail;
        else
          _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }



  Future<void> verifyEmail(
      String email,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      if (email.endsWith(".edu") != true) email = "";
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email); // this will throw an exception if invalid email is supplied
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}