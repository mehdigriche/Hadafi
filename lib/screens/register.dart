import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadafi/components/hadafi_textfield_datepicker.dart';
import 'package:intl/intl.dart';
import '../util/hadafi_util.dart';
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
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthdayController = TextEditingController();

  bool _isEmailVerified = false;
  bool _isPasswordVerified = false;
  bool _isFullNameVerified = false;
  bool _isBirthdayVerified = false;

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
      // create user
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // add user to firestore
      cellectUserToFirestore(userCredential);

      // pop the loading circle
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error to user
      registerErrorPopup(e.code);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Collect user in firestore
  Future<void> cellectUserToFirestore(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'fullname': _fullNameController.text,
        'birthday': _birthdayController.text
      });
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
    return _isPasswordVerified &&
        _isEmailVerified &&
        _isFullNameVerified &&
        _isBirthdayVerified;
  }

  // date picker for birthday
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('yyyy-MM-dd')
            .format(picked); // Format the date as needed
        _isBirthdayVerified = true;
      });
    } else {
      _isBirthdayVerified = false;
    }
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
                  Icons.person_add,
                  size: 70,
                ),

                const SizedBox(height: 25),

                // Let's create an account for you!
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 25),

                // fullname textfield
                HadafiTextField(
                  controller: _fullNameController,
                  onChanged: (value) {
                    debugPrint(value);

                    // run name checker
                    setState(() {
                      _isFullNameVerified = isFullNameVerified(value);
                    });
                  },
                  hintText: 'Enter your full name',
                  isPassword: false,
                ),

                const SizedBox(height: 10),

                HadafiTextFieldDatePicker(
                  controller: _birthdayController,
                  hintText: 'Select your birthday',
                  onTap: () => _selectDate(context),
                ),

                const SizedBox(height: 10),

                // email textfield
                HadafiTextField(
                  controller: _emailController,
                  onChanged: (value) {
                    debugPrint(value);
                    // run email checker
                    setState(() {
                      _isEmailVerified = EmailValidator.validate(value);
                    });
                  },
                  hintText: 'Enter your email',
                  isPassword: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                HadafiTextField(
                  controller: _passwordController,
                  onChanged: (value) {
                    debugPrint(value);
                    // run password checker
                    setState(() {
                      _isPasswordVerified =
                          value == _confirmPasswordController.text;
                    });
                  },
                  hintText: 'Password',
                  isPassword: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                HadafiTextField(
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    debugPrint(value);
                    // run confirm password checker
                    setState(() {
                      _isPasswordVerified = value == _passwordController.text;
                    });
                  },
                  hintText: 'Confirm Password',
                  isPassword: true,
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

                // google + apple sign up buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HadafiSocialSignInButton(
                        action: () {
                          //Perform login with Apple
                          debugPrint('Perform login with Apple');
                        },
                        imagePath: 'assets/images/appleSignInButton.png'),
                    const SizedBox(width: 25),
                    HadafiSocialSignInButton(
                        action: () {
                          //Perform login with Google
                          debugPrint('Perform login with Google');
                        },
                        imagePath: 'assets/images/googleSignInButton.png')
                  ],
                ),

                // Already have an account? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        debugPrint('Login clicked');
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login now',
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
