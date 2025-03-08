import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:health_sync_client/features/auth/presentation/screens/login.dart';
import 'package:health_sync_client/features/auth/presentation/screens/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffDCC9FB),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: .5,
                image:
                    Image.asset('assets/illustrations/backgrndauth.jpg').image,
                fit: BoxFit.cover)),
        child: FlipCard(
          key: cardKey,
          front: LoginPage(onFlip: () {
            cardKey.currentState!.toggleCard();
          }),
          back: SignupPage(onFlip: () {
            cardKey.currentState!.toggleCard();
          }),
          flipOnTouch: false,
        ),
      ),
    );
  }
}
