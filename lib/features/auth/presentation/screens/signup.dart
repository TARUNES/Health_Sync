import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/getDatascreen.dart';
import 'package:health_sync_client/features/auth/presentation/screens/login.dart';
import 'package:health_sync_client/features/auth/presentation/widgets/frosted-design.dart';
import 'package:health_sync_client/features/auth/presentation/widgets/user_input.dart';
import 'package:health_sync_client/features/home/presentation/screens/home.dart';
import 'package:health_sync_client/features/initial_page.dart';
// import 'package:health_sync_client/features/auth/data/auth_service.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onFlip;
  const SignupPage({super.key, required this.onFlip});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final AuthService authService = AuthService();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await authService.signUpUser(
      emailController.text.trim(),
      passwordController.text.trim(),
      nameController.text.trim(),
    );

    setState(() => isLoading = false);

    if (response != null) {
      final user = response["user"];
      final token = response["token"];

      print("✅ Signup Successful! Full Response: $response");
      print("👤 User Data: $user");
      print("🔑 Token: $token");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful! Welcome ${user["name"]}")),
      );

      // ✅ Only one navigation call here
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetDataPatient()),
      );
    } else {
      print("❌ Signup Failed!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignUpWidget(
      nameController: nameController,
      emailController: emailController,
      passwordController: passwordController,
      onFlip: widget.onFlip,
      isLoading: isLoading,
      onSignUp: signUp,
    );
  }
}

class SignUpWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onFlip;
  final bool isLoading;
  final VoidCallback onSignUp;

  const SignUpWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onFlip,
    required this.isLoading,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FrostedGlass(
        height: 480,
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
              const SizedBox(height: 20),
              UserInput(
                icon: const Icon(Icons.person),
                controller: nameController,
                hintText: 'Full Name',
              ),
              const SizedBox(height: 15),
              UserInput(
                icon: const Icon(Icons.email),
                controller: emailController,
                hintText: 'Email',
              ),
              const SizedBox(height: 15),
              UserInput(
                icon: const Icon(Icons.lock),
                controller: passwordController,
                hintText: 'Password',
                // obscureText: true,
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
