import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Success.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  bool isLoading = false;

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Send verification email immediately if not sent
    if (user != null && !user!.emailVerified) {
      user!.sendEmailVerification();
    }
  }

  Future<void> checkEmailVerified() async {
    setState(() => isLoading = true);

    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user!.emailVerified) {
      setState(() => isEmailVerified = true);

      // Navigate to Success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Success()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email not verified yet.")),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> resendVerificationEmail() async {
    if (!canResendEmail) return;

    try {
      await user?.sendEmailVerification();
      setState(() => canResendEmail = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email sent!")),
      );

      // Allow resend after 30 seconds
      await Future.delayed(const Duration(seconds: 30));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFE),
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [

              /// TOP IMAGE
              SizedBox(
                height: screenHeight * 0.25,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/95C2mfKlGI/l0se2r8f_expires_30_days.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Check your email",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D5480),
                ),
              ),
              const SizedBox(height: 6),

              /// DESCRIPTION
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Text(
                  "We've sent a verification email to your inbox.\nPlease click the link to verify your account.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9FA5C0),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              /// BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [

                    /// CHECK VERIFICATION BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AA5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: isLoading ? null : checkEmailVerified,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "I have verified",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// RESEND VERIFICATION EMAIL
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: canResendEmail ? resendVerificationEmail : null,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          side: const BorderSide(color: Color(0xFF007AA5)),
                        ),
                        child: const Text(
                          "Resend Verification Email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007AA5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// BOTTOM IMAGE
              SizedBox(
                height: screenHeight * 0.2,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/95C2mfKlGI/qhx5qg0z_expires_30_days.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
