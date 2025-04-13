import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_sync_client/core/routes/mainRoute.dart';
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

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/google_logo.png', // Add this image to your assets
                    //   height: 24,
                    //   width: 24,
                    // ),
                    Icon(Icons.g_mobiledata, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false; // To show the loading indicator
  bool isGoogleSignInLoading = false;

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
          MaterialPageRoute(builder: (context) => MainRoute()),
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

  void signInWithGoogle() async {
    setState(() => isGoogleSignInLoading = true);

    try {
      final authService = AuthService();
      final response = await authService.signInWithGoogle();

      if (response != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainRoute()),
        );
      } else {
        showError("Google sign-in failed or was canceled");
      }
    } catch (e) {
      showError("An error occurred during Google sign-in");
      debugPrint("Google sign-in error: $e");
    } finally {
      if (mounted) {
        setState(() => isGoogleSignInLoading = false);
      }
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
      onGoogleSignIn: signInWithGoogle,
      isGoogleSignInLoading: isGoogleSignInLoading,
    );
  }
}

class LoginWidget extends StatelessWidget {
  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback onFlip;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onGoogleSignIn;
  final bool isGoogleSignInLoading;

  const LoginWidget({
    Key? key,
    required this.username,
    required this.password,
    required this.onFlip,
    required this.isLoading,
    required this.onLogin,
    required this.onGoogleSignIn,
    this.isGoogleSignInLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FrostedGlass(
        height: 500, // Increased height to accommodate the Google button
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
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 15),
              GoogleSignInButton(
                onPressed: onGoogleSignIn,
                isLoading: isGoogleSignInLoading,
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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // For iOS devices, use your iOS client ID also
    clientId:
        '532745854641-tkcf9fepfa26rbafmo0900k1r108via4.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use the accessToken and idToken to authenticate with your server
      final response = await http.post(
        Uri.parse('$baseUrl/google/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to authenticate with the server');
      }

      final data = jsonDecode(response.body);
      await saveUserData(data);

      return data;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login/user"),
        headers: {"Content-Type": "application/json"},
        body:
            jsonEncode({"email": email, "password": password, "role": "user"}),
      );
      print("$baseUrl/login/user");

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
