import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'package:randuraft_web_app/profile/user_model.dart';
import 'welcome.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        debugPrint("Sign up successful for email: ${_emailController.text}");
        UserModel userModel = UserModel(
            uid: userCredential.user!.uid, email: userCredential.user!.email);

        debugPrint("UserModel: uid=${userModel.uid}, email=${userModel.email}");
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Successfully Signed Up!')),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WelcomeScreen(user: userCredential.user)));
        }
      } catch (e) {
        debugPrint("Sign up failed with error: $e");
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Sign Up Failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF102425), Color(0xFF723873)],
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Header
              _buildCustomHeader(),
              // Sign Up Form
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInputField(
                              'Email', 'Enter your email', _emailController),
                          const SizedBox(height: 20),
                          _buildInputField('Password', 'Enter your password',
                              _passwordController),
                          const SizedBox(height: 40),
                          _buildSignUpButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      width: double.infinity,
      height: 98,
      color: const Color(0xFFF2C9E7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Randuraft',
              style: TextStyle(
                color: Color(0xFFBE60AE),
                fontSize: 32,
                fontFamily: 'Noto Sans Japanese',
                fontWeight: FontWeight.w900,
              ),
            ),
            GestureDetector(
              // GestureDetectorを追加
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SignInScreen()), // SignInScreenに遷移
                );
              },
              child: const Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'Noto Sans Japanese',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller, // この行を追加
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFFD0C7C7),
          fontSize: 20,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFF723873),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Color(0xFFBE60AE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: Color(0xFFBE60AE)),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _signUp, // ここで_signUpメソッドを呼び出します
      style: ElevatedButton.styleFrom(
        //primary: Color(0xFF102425),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: const Text(
        'Sign up',
        style: TextStyle(
          color: Color(0xFFF2C9E7),
          fontSize: 20,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
