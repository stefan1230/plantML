import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantdiseaseidentifcationml/app_color.dart';
import 'package:plantdiseaseidentifcationml/commonComponents/common_text_widget.dart';
import 'package:plantdiseaseidentifcationml/screens/controller_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isRegistering = false;
  bool _rememberMe = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OutlineInputBorder customBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 0.5),
    );
  }

  bool _isLoading = false; // Add this line

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = result.user;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ControllerScreen()),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

Future<void> _handleRegister() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = result.user;

      if (user != null) {
        await user.updateProfile(
          displayName: "${_firstNameController.text} ${_lastNameController.text}"
        );
        
        // Create a user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ControllerScreen()),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const TextWidget(
                text: 'Welcome!',
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (_isRegistering) _firstName(),
                    if (_isRegistering) const SizedBox(height: 18),
                    if (_isRegistering) _lastName(),
                    if (_isRegistering) const SizedBox(height: 18),
                    _emailAddress(),
                    const SizedBox(height: 18),
                    _password(),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        const TextWidget(
                          text: 'Remember me',
                          fontSize: 16,
                        ),
                        const Spacer(),
                        if (!_isRegistering)
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: const TextWidget(
                              text: 'Forgot password?',
                              color: AppColors.MainGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          _isRegistering ? _handleRegister : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.MainGreen,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: _isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Logging in...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : TextWidget(
                              text: _isRegistering ? 'Register' : 'Login',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: TextWidget(
                        text: _isRegistering
                            ? 'Already have an account? Login'
                            : 'Create an account',
                        fontWeight: FontWeight.w700,
                        color: AppColors.MainGreen,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: 'First Name',
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _firstNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Enter your first name',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            focusedBorder: customBorder(AppColors.MainGreen),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: 'Last Name',
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _lastNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Enter your last name',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            focusedBorder: customBorder(AppColors.MainGreen),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: 'Email',
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            hintText: 'Enter your email',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            focusedBorder: customBorder(AppColors.MainGreen),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              // borderSide: BorderSide(width: 0.2, color: Colors.red.shade50),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: 'Password',
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Enter your password',
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            focusedBorder: customBorder(AppColors.MainGreen),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
