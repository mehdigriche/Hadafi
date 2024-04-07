import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadafi/screens/register.dart';
import 'package:hadafi/services/auth_service.dart';
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
  bool _isPasswordNotEmpty = false;
  bool _isEmailVerified = false;

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
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error to user
      loginErrorPopup(e.code);
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

  // Verify user inputs
  bool isSignInEnabled() {
    return _isPasswordNotEmpty && _isEmailVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                HadafiTextField(
                  controller: _emailController,
                  onChanged: (email) {
                    debugPrint(
                        '$email / value of _isEmailVerified : $_isEmailVerified');
                    // run email checker
                    setState(() {
                      _isEmailVerified = EmailValidator.validate(email);
                    });
                  },
                  hintText: 'Enter your email',
                  isPassword: false,
                ),

                const SizedBox(height: 25),

                // password textfield
                HadafiTextField(
                  controller: _passwordController,
                  onChanged: (text) {
                    debugPrint(
                        '$text / value of _isPasswordNotEmpty : $_isPasswordNotEmpty');
                    // run email checker
                    setState(() {
                      _isPasswordNotEmpty = text.toString().isNotEmpty;
                    });
                  },
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
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                HadafiButton(
                  onPressed: signUserIn,
                  buttonText: 'Sign In',
                  isEnabled: isSignInEnabled(),
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
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HadafiSocialSignInButton(
                      action: () {
                        //Perform login with Apple
                        debugPrint('Perform login with Apple');
                      },
                      imagePath: 'assets/images/appleSignInButton.png',
                    ),
                    const SizedBox(width: 25),
                    HadafiSocialSignInButton(
                      action: () {
                        //Perform login with Google
                        debugPrint('Perform login with Google');
                        AuthService().signInWithGoogle().then((_) {
                          // Navigate to the home page
                          Navigator.pushReplacementNamed(context, '/home');
                        });
                      },
                      imagePath: 'assets/images/googleSignInButton.png',
                    )
                  ],
                ),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        debugPrint('Register clicked');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue[500],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
