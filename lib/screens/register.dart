import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadafi/screens/home.dart';
import '../components/hadafi_button.dart';
import '../components/hadafi_social_signin_button.dart';
import '../components/hadafi_textfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVerified = false;
  bool _isEmailVerified = false;

  // Sign user in method
  void signUpUser() async {
    debugPrint('Sign up clicked');
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try sign up
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // pop the loading circle
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        // show error to user
        registerErrorPopup('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // show error to user
        registerErrorPopup('The account already exists for that email.');
      } else {
        // show error to user
        registerErrorPopup('Something went wrong, try again later!');
      }
    } catch (e) {
      print(e);
    }
  }

  // Register error message popup
  void registerErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  // Verify user inputs
  bool isSignUpEnabled() {
    return _isPasswordVerified && _isEmailVerified;
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
                Icons.person_add,
                size: 70,
              ),

              const SizedBox(height: 25),

              // Let's create an account for you!
              Text(
                'Let\'s create an account for you!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              HadafiTextField(
                controller: _emailController,
                onChanged: (text) {
                  print(text);
                  // run email checker
                  setState(() {
                    _isEmailVerified = text.toString().contains("@");
                  });
                },
                hintText: 'Enter your email',
                isPassword: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              HadafiTextField(
                controller: _passwordController,
                onChanged: (text) {
                  print(text);
                  // run password checker
                  setState(() {
                    _isPasswordVerified =
                        text == _confirmPasswordController.text;
                  });
                },
                hintText: 'Password',
                isPassword: true,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              HadafiTextField(
                controller: _confirmPasswordController,
                onChanged: (text) {
                  print(text);
                  // run confirm password checker
                  setState(() {
                    _isPasswordVerified = text == _passwordController.text;
                  });
                },
                hintText: 'Confirm Password',
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
                onPressed: signUpUser,
                buttonText: 'Sign Up',
                isEnabled: isSignUpEnabled(),
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

              // google + apple sign up buttons
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

              // Already have an account? login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Login now',
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
