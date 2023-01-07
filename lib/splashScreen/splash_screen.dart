import 'dart:async';

import 'package:chaudhary_chicken_users_app/global/global.dart';
import 'package:flutter/material.dart';

import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 320),
          child: ClipPath(
            clipper: ClippingClass(),
            child: Container(
              color: const Color(0xfffb9e5a),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Chaudhary Chicken", style: TextStyle(
                      fontSize: 34,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                      letterSpacing: 3
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Curve for orange colour container
class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    var path = Path();

    path.lineTo(0.0, size.height-40);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
