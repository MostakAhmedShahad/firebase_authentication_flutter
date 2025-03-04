import 'package:firebase_authentication_flutter/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
            const Padding(
              
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter user name'),
              ),
            ),
           const Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter email address'),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              
              child: TextField(
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
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  
                  child: const Text(
                    'Sign up ',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300, fontSize: 20),
                    
                  ),
                  onPressed: () {
                    print('Successfully log in ');
                  },
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
