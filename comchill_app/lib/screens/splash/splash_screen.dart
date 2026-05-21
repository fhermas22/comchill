import 'package:flutter/material.dart';
import 'package:comchill_app/screens/splash/controller/controller.dart'; 
import 'package:comchill_app/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    time(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo/comchill_logo.png'),
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20),
                Text(
                  'ComChill',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ) ,
              ),
              SizedBox(height: 10),
                          Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: primaryColor, 
                    shape: BoxShape.circle,   
                  ),
                ),
                const SizedBox(width: 8), 
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE47E3A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8), 
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            )


            ]
          ),
        ),
      ),
    );
  }
}