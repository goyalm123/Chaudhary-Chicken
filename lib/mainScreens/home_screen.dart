import 'package:chaudhary_chicken_users_app/mainScreens/user_profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../authentication/auth_screen.dart';
import '../global/global.dart';
import 'screen1.dart';
import 'screen2.dart';
import 'screen3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index = 1;

  final screens = [
    const Screen1(),
    const Screen2(),
    const Screen3(),
  ];

  _showModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xfffb9e5a).withOpacity(0.6),
                    blurRadius: 60,
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.person_outlined),
                    title: const Text('Profile'),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> const UserProfile()));
                    },
                  ),
                  const ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app_outlined),
                    title: const Text('Sign Out'),
                    onTap: () async {
                      Navigator.pop(context);
                      await firebaseAuth.signOut().then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    //Items of Bottom Navigation Bar
    final items = <Widget> [
      const Icon(Icons.discount, size: 30,),
      const Icon(Icons.home, size: 30,),
      const Icon(Icons.shopping_cart, size: 30,),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            color: Colors.black,
            onPressed: () {
              _showModalBottomSheet(context);
            },
          ),
        ],
        title: Text("Welcome ${sharedPreferences!.getString("name")} !", style: const TextStyle(
          color: Colors.black,
        ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xfffb9e5a),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ClipRect(
        child: Scaffold(
          extendBody: true,
          // Bottom Navigation Bar
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: const Color(0xfffb9e5a),
              buttonBackgroundColor: const Color(0xfffb9e5a).withOpacity(0.6),
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              height: 50,
              index: index,
              items: items,
              onTap: (index) => setState(() => this.index = index),
            ),
          ),
          body: screens [index],
        ),
      ),
    );
  }
}
