import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_shopping_v1/buyerhome.dart';

import '../pages/itemDetailPage.dart';
import '../pages/verifyEmail.dart';
import '../widgets.dart';

bool isFirstSignUp = false;

void getProfileDb (String? email, String? name, String? uid) {
  var initFuture = addProfileToDBHelper(email, name, uid);
  initFuture.then((voidValue) {
//      notifyListeners();
  });
}

 Future<void> addProfileToDBHelper(String? email, String? name, String? uid) async {
   await addProfileToDB(email, name, uid);
 }

Future<void> addProfileToDB(String? email, String? name, String? uid) async {

  http.post(
    Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'emailId': email!,
      'name': name!,
      'description': name,
      'firebaseUID' : uid!
    }),
  );
  print("Done with adding profile");
}

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  verifyEmail,
  register,
  password,
  loggedIn,
  unVerifiedEmail,
}

class Authentication extends StatelessWidget {
  const Authentication({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
      String email,
      void Function(Exception e) error,
      ) verifyEmail;
  final void Function(
      String email,
      String password,
      void Function(Exception e) error,
      ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
      String email,
      String displayName,
      String password,
      void Function(Exception e) error,
      ) registerAccount;
  final void Function() signOut;


  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 0),
              child: Center(
                child: StyledButton(

                  onPressed: () {
                    startLoginFlow();
                  },
                  child: const Text('Login or Register',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, 'Invalid Email. Please use a valid .edu email', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email!,
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                    (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
              email,
              displayName,
              password,
              ) {
            registerAccount(
                email,
                displayName,
                password,
                    (e) =>
                    _showErrorDialog(context, 'Failed to create account', e));
          },
        )
        ;
      case ApplicationLoginState.unVerifiedEmail:
        isFirstSignUp = true;
        return VerifyScreen();
      case ApplicationLoginState.loggedIn:
        User? currentUser = FirebaseAuth.instance.currentUser;
            WidgetsBinding.instance!.addPostFrameCallback((_){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => BuyerHomePage('Student Shop'), fullscreenDialog: true));
              // Navigator.pushNamed(context, '/buyerhome');
            },);
        // return null as Widget;
        return Container(
          child: Center(child: spinkit),
        );
        //   Row(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 24, bottom: 8),
        //       child: StyledButton(
        //         onPressed: () {
        //           signOut();
        //         },
        //         child: const Text('LOGOUT'),
        //       ),
        //     ),
        //   ],
        // );

      default:
        return Row(
          children: const [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({required this.callback});
  final void Function(String email) callback;
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Sign in with email'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email address to continue';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        child: const Text('NEXT',style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    required this.registerAccount,
    required this.cancel,
    required this.email,
  });
  final String email;
  final void Function(String email, String displayName, String password)
  registerAccount;
  final void Function() cancel;
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Create account'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email address to continue';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 24),
                //   child: TextFormField(
                //     controller: _emailController,
                //     decoration: const InputDecoration(
                //       hintText: 'Enter your email',
                //     ),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Enter your email address to continue';
                //       }
                //       return null;
                //     },
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'First Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),

                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),

                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 24),
                //   child: TextFormField(
                //     controller: _displayNameController,
                //     decoration: const InputDecoration(
                //       hintText: 'First & last name',
                //     ),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Enter your account name';
                //       }
                //       return null;
                //     },
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 24),
                //   child: TextFormField(
                //     controller: _passwordController,
                //     decoration: const InputDecoration(
                //       hintText: 'Password',
                //     ),
                //     obscureText: true,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Enter your password';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.cancel,
                        child: const Text('CANCEL', style: TextStyle(color: Colors.black),),
                      ),
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // if(_emailController.text.endsWith('@ufl.edu')){
                            //   widget.registerAccount(
                            //     _emailController.text,
                            //     _displayNameController.text,
                            //     _passwordController.text,
                            //   );
                            // }
                              widget.registerAccount(
                                _emailController.text,
                                _firstNameController.text + " " + _lastNameController.text,
                                _passwordController.text,
                              );


                          }
                        },
                        child: const Text('SAVE',style: TextStyle(color: Colors.black),),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({
    required this.login,
    required this.email,
  });
  final String email;
  final void Function(String email, String password) login;
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Sign in'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email address to continue';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your password to continue';
                          }
                          return null;
                        },
                      ),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text('SIGN IN', style: TextStyle(color: Colors.black),),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
Future<void> getProfileFromDbAndCheckIfExist (String? email, String? displayName ,String? firebaseid) async {
  Map<String, dynamic> data;
  var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
  http.Response response = await http.get(
      url, headers: {"Accept": "application/json"});
  if (response.statusCode == 200) {
    // data.map<Item>((json) => Item.fromJson(json)).toList();
    try {
      getProfileDb(email,displayName,firebaseid);
      // data = jsonDecode(response.body);
      // var profile = data['content'];
      // print(response.statusCode);
    } catch(e){
      // getProfileDb(email,displayName,firebaseid);
      print(response.statusCode);
      }
    }
}