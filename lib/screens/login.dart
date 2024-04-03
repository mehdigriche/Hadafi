import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadafi/screens/register.dart';
import '../components/hadafi_button.dart';
import '../components/hadafi_social_signin_button.dart';
import '../components/hadafi_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Text editing controllers
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() async {
    debugPrint('Sign in clicked');
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        // show error to user
        loginErrorPopup('No user found for that email');
      } else if (e.code == 'wrong password') {
        // show error to user
        loginErrorPopup('Wrong password provided for that user.');
      } else {
        // show error to user
        loginErrorPopup('Something went wrong, try again later!');
      }
    }
  }

  // login error message popup
  void loginErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              HadafiTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                isPassword: false,
              ),

              const SizedBox(height: 25),

              // password textfield
              HadafiTextField(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),

              const SizedBox(height: 25),

              // forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              HadafiButton(
                onPressed: signUserIn,
                buttonText: 'Sign In',
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HadafiSocialSignInButton(
                      imagePath: 'assets/images/appleSignInButton.png'),
                  SizedBox(width: 25),
                  HadafiSocialSignInButton(
                      imagePath: 'assets/images/googleSignInButton.png')
                ],
              ),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      debugPrint('Register clicked');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Register now',
                      style: TextStyle(
                          color: Colors.blue[500], fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
