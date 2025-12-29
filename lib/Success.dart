import 'package:flutter/material.dart';
import 'SignInLogin.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// SUCCESS IMAGE
                Container(
                  width: 106,
                  height: 106,
                  margin: const EdgeInsets.only(bottom: 48),
                  child: Image.network(
                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/95C2mfKlGI/pwew5qjr_expires_30_days.png",
                    fit: BoxFit.fill,
                  ),
                ),

                /// TITLE
                const Text(
                  "Success!",
                  style: TextStyle(
                    color: Color(0xFF313131),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                /// MESSAGE
                const Text(
                  "Congratulations! You have been successfully authenticated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB5B5B5),
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 77),

                /// CONTINUE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignInLogin(),
                        ),
                      );
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
