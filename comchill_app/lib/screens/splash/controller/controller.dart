import 'package:flutter/material.dart';
import 'package:comchill_app/screens/onboarding/onboarding_screen.dart';


void time(BuildContext context){
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
  });
}