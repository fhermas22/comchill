import 'package:flutter/material.dart';
import 'package:comchill_app/widgets/custom_outlined_button.dart';
import 'package:comchill_app/screens/auth/login_screen.dart';
import 'package:comchill_app/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:comchill_app/screens/auth/register_with_password_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                  image: AssetImage('assets/images/logo/comchill_logo.png'),
                  height: 100,
                  width: 100,
                ),
               const SizedBox(height: 34),
              CustomOutlinedButton(
                label: "S\'inscrire avec Google",
                prefixIcon: const FaIcon(FontAwesomeIcons.google),
                onPressed: () {},
              ),
              const SizedBox(height: 5),
              CustomOutlinedButton(
                label: "S\'inscrire avec Github",
                prefixIcon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () {},
              ),
              const SizedBox(height: 5),
              CustomOutlinedButton(
                label: "S\'inscrire avec Mot de passe",
                prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterWithScreen()));
                },

              ),
              const SizedBox(height: 10),
               Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Vous aviez déjà un compte ?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                      child: const Text('Se connecter', style: TextStyle(color: primaryColor),),
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