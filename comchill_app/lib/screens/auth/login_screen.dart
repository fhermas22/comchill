import 'package:comchill_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:comchill_app/widgets/custom_eleveted_button.dart';
import 'package:comchill_app/widgets/custom_outlined_button.dart';
import 'package:comchill_app/screens/auth/register_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                label: "Se connecter avec Google",
                prefixIcon: const FaIcon(FontAwesomeIcons.google),
                onPressed: () {},
              ),
              const SizedBox(height: 5),
              CustomOutlinedButton(
                label: "Se connecter avec Github",
                prefixIcon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () {},
              ),
              const SizedBox(height: 5),
              CustomOutlinedButton(
                label: "Se connecter avec Mot de passe",
                prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                onPressed: () {},
              ),
              const SizedBox(height: 10),
               Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Vous n'avez pas de compte ?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                      child: const Text('S\'inscrire', style: TextStyle(color: primaryColor),),
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

