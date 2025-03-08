import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_sync_client/features/auth/presentation/widgets/frosted-design.dart';
import 'package:health_sync_client/features/auth/presentation/widgets/user_input.dart';
import 'package:health_sync_client/features/home/presentation/screens/home.dart';
import 'package:health_sync_client/features/initial_page.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onFlip;
  const SignupPage({super.key, required this.onFlip});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void signUp() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    if (username.text == "user@example.com") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. Try again.")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SignUpWidget(
      username: username,
      password: password,
      onFlip: widget.onFlip,
      isLoading: isLoading,
      onSignUp: signUp,
    );
  }
}

class SignUpWidget extends StatelessWidget {
  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback onFlip;
  final bool isLoading;
  final VoidCallback onSignUp;

  const SignUpWidget({
    super.key,
    required this.username,
    required this.password,
    required this.onFlip,
    required this.isLoading,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FrostedGlass(
        height: 430,
        width: 350,
        borderradius: 20,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
          child: Column(
            children: [
              Text(
                'Sign Up and Sip In!',
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                  fontSize: 25,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),
              UserInput(
                icon: const Icon(Icons.person),
                controller: username,
                hintText: 'Email',
              ),
              const SizedBox(height: 15),
              UserInput(
                icon: const Icon(Icons.password),
                controller: password,
                hintText: 'Password',
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: isLoading ? null : onSignUp,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 110, 121, 238),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Sign Up',
                            style: GoogleFonts.sora(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.arimo(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: onFlip,
                    child: Text(
                      'Login',
                      style: GoogleFonts.arimo(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 110, 121, 238),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
