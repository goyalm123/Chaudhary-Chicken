import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Color(0xfffb9e5a),
              ),
            ),
            automaticallyImplyLeading: false,
            title: Text("Chaudhary Chicken"),
            bottom: const TabBar(
              labelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.black,),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(Icons.person, color: Colors.black,),
                    text: "Register",
                  ),
                ],
              indicatorColor: Colors.black12,
              indicatorWeight: 4,
            ),
          ),
          body: Container(
            color: Colors.white,
            child: const TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen(),
              ],
            ),
          ),
        ),
    );
  }
}
