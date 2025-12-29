import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';
import 'SignUp.dart';

class SignInLogin extends StatefulWidget {
  const SignInLogin({super.key});

  @override
  State<SignInLogin> createState() => _SignInLoginState();
}

class _SignInLoginState extends State<SignInLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  /// 🔹 LOGIN
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) return;

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 🔹 FORGOT PASSWORD
  Future<void> forgotPassword() async {
    final TextEditingController resetEmailController =
    TextEditingController(text: emailController.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          controller: resetEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "Enter your email",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (resetEmailController.text.isEmpty) return;

              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: resetEmailController.text.trim(),
                );
                Navigator.pop(context);
                _showMessage("Password reset email sent!");
              } catch (e) {
                Navigator.pop(context);
                _showMessage(e.toString());
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFCFCFE),
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 TOP RIGHT VECTOR
            Positioned(
              top: -40,
              right: -60,
              child: Image.asset(
                "assets/images/Vector1.png",
                width: 260,
              ),
            ),

            /// 🔹 BOTTOM LEFT VECTOR
            Positioned(
              bottom: 10,
              left: -5,
              child: Image.asset(
                "assets/images/Vector2.png",
                width: 260,
              ),
            ),

            /// 🔹 CENTER CONTENT
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3D5C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Please enter your account here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9FA5C0),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// EMAIL
                    _inputField(
                      controller: emailController,
                      hint: "Email or phone number",
                      icon: Icons.email_outlined,
                      obscureText: false,
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    _inputField(
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscureText: !isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF9FA5C0),
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: forgotPassword,
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Color(0xFF2D3D5C)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AA5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: isLoading ? null : loginUser,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have any account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignUp()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFF007AA5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF007AA5), width: 1.5),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9FA5C0)),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFF9FA5C0)),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
