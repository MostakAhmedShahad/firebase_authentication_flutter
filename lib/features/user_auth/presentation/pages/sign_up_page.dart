import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_flutter/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/home_page.dart';
import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_authentication_flutter/global/common/toust.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
   final _nameEditingController = TextEditingController();
  final TextEditingController _emaiEditingController = TextEditingController();
  final  _passwordEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameEditingController.dispose();
    _emaiEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  void _signUp() async {
    //String username = _nameEditingController.text;
    String email = _emaiEditingController.text;
    String password = _passwordEditingController.text;
    if (email.isEmpty || password.isEmpty) {
      //print("Email or password cannot be empty");
      setState(() {
        isLoading = false;
      });
      return;
    }
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      showToast(message: 'User is successfully created');
      // Navigator.pushNamed(context, "/home");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showToast(message: 'Some error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: Text(
              'Fill the information',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _nameEditingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter user name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: _emaiEditingController,
                obscureText: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter email address'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                  child:  isLoading? CircularProgressIndicator(color: Colors.white,): Text(
                    'Sign up ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20),
                  ),
                  onPressed: isLoading? null: _signUp,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
                child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 62),
                    child: Text('Already have account? '),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => true);
                        },
                        child: const Text(
                          'Sign in...',
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
