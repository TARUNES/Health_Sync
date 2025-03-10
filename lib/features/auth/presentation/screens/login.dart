import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_sync_client/features/auth/presentation/widgets/frosted-design.dart';
import 'package:health_sync_client/features/auth/presentation/widgets/user_input.dart';
import 'package:health_sync_client/features/home/presentation/screens/home.dart';
import 'package:health_sync_client/features/initial_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onFlip;
  const LoginPage({super.key, required this.onFlip});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false; // To show the loading indicator

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void login() async {
    setState(() => isLoading = true);

    try {
      final authService = AuthService();
      final response =
          await authService.loginUser(username.text, password.text);

      if (response != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        showError("Invalid email or password");
      }
    } catch (e) {
      showError("An error occurred. Please try again.");
      debugPrint("Login error: $e"); // Log error for debugging
    } finally {
      if (mounted)
        setState(() => isLoading =
            false); // Ensure widget is mounted before calling setState
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginWidget(
      username: username,
      password: password,
      onFlip: widget.onFlip,
      isLoading: isLoading,
      onLogin: login,
    );
  }
}

class LoginWidget extends StatelessWidget {
  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback onFlip;
  final bool isLoading;
  final VoidCallback onLogin;

  const LoginWidget({
    super.key,
    required this.username,
    required this.password,
    required this.onFlip,
    required this.isLoading,
    required this.onLogin,
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
                'Welcome Back!',
                style: GoogleFonts.oswald(
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
                onTap: isLoading ? null : onLogin,
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
                            'Login',
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
                    'Don\'t have an account? ',
                    style: GoogleFonts.arimo(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: onFlip,
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.arimo(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 110, 121, 238),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthService {
  final String baseUrl =
      "http://172.31.135.242:8080/auth"; // Replace with your backend URL

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login/user"),
        headers: {"Content-Type": "application/json"},
        body:
            jsonEncode({"email": email, "password": password, "role": "user"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveUserData(data); // Store token
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> signUpUser(
      String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register/user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "role": "user",
          "name": name
        }),
      );
      print("Responsse: ${response.body}");

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await saveUserData(data); // Store token
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", data["token"]);
    await prefs.setString("user", jsonEncode(data["user"]));
  }
}
