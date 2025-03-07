import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_flutter/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/home_page.dart';
import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:firebase_authentication_flutter/global/common/toust.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController _emaiEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose

    _emaiEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  void _signIn() async {
    setState(() {
      isLoading = true;
    });

    String email = _emaiEditingController.text.trim();
    String password = _passwordEditingController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print("Email or password cannot be empty");
      setState(() {
        isLoading = false;
      });
      return;
    }
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      showToast(message: 'User is successfully login');
      // Navigator.pushNamed(context, "/home");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showToast(message: 'Some error occured');
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      //clientId: '964865312791-c9nmbie71kudur3dqrglosas85soq0go.apps.googleusercontent.com' 1005179153071-23jm0ht66df87qfd26oupmod50qhd4hm.apps.googleusercontent.com
      clientId: ' 1005179153071-23jm0ht66df87qfd26oupmod50qhd4hm.apps.googleusercontent.com'
                 
    );
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      showToast(message: "some erroe occuredd $e");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _emaiEditingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number, email or username',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _passwordEditingController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Log in ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                        ),
                  onPressed: isLoading ? null : _signIn,
                ),
              ),
            ),
            SizedBox(
              height: 90,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Sign in With google ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed:_signInWithGoogle(),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 62),
                    child: Text('Do not have account? '),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                              (route) => true);
                        },
                        child: Text(
                          'Sign up...',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        )),
                  )
                ],
              ),
            ))
          ]),
    );
  }
}
