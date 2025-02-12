import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Use body as the top-level widget
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal[700]!,
              Colors.teal[200]!
            ], // Adjust colors for desired effect
          ),
        ),
        child: SafeArea(
          // Add SafeArea
          child: Center(
            // Center the content
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 40), // Space at the top
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 26, // Slightly larger font
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            // Add a subtle shadow
                            Shadow(
                              blurRadius: 3.0,
                              color: Colors.black38,
                              offset: Offset(1.0, 1.0),
                            )
                          ]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter your email to receive a password reset link.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9)), // Lighter text
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildResetButton(), // Use a dedicated button widget
                    const SizedBox(height: 40), // Space at the bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.teal[200]), // Lighter icon
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 20), // Adjust padding
        labelStyle:
            TextStyle(color: Colors.white.withOpacity(0.9)), // Lighter text
        hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.7)), // Lighter text
        errorStyle: const TextStyle(
            color: Colors.yellow), // Use a standard yellow for errors
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
    );
  }

  Widget _buildResetButton() {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // More subtle shadow
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal[800],
          padding:
              const EdgeInsets.symmetric(vertical: 16.0), // Consistent padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _resetPassword(context);
          }
        },
        child: const Text(
          'Send Reset Link',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600), // Bolder text
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        },
      );

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Navigator.of(context).pop(); // Hide loading indicator
      _showSuccessDialog(
          context, "Password reset email sent. Check your inbox.");
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Hide loading
      String errorMessage = "An error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email you enter is invalid';
      }
      _showErrorDialog(context, errorMessage);
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading
      _showErrorDialog(
          context, "An unexpected error occurred: ${e.toString()}");
      print(e); // Log for debugging
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.teal)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login page
              },
            ),
          ],
        );
      },
    );
  }
}
