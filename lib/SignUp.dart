import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'VerificationCode.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user?.sendEmailVerification();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerificationCode()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";
      if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters";
      } else if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // ⚡ keeps vectors fixed
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
                      "Welcome to your Cookify!",
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

                    // EMAIL
                    _inputField(
                      controller: emailController,
                      hint: "Email or phone number",
                      icon: Icons.email_outlined,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
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
                    const SizedBox(height: 32),

                    // SIGN UP BUTTON
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
                        onPressed: isLoading ? null : signUpWithEmail,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Sign Up",
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
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF007AA5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40), // extra bottom padding
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
