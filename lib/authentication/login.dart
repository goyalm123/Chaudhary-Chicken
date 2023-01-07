import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation(){
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      loginNow();
    }
    else{
      showDialog(context: context, builder: (c){return ErrorDialog(message: "Please fill the details correctly",);});
    }
  }

  loginNow() async{
    showDialog(context: context, builder: (c){return LoadingDialog(message: "Logging in",);});
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim()).then((auth) {
      currentUser = auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c){return ErrorDialog(message: error.message.toString(),);});
    });
    if(currentUser != null){
      readAndSetDataLocally(currentUser!);
    }
  }

  Future readAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).get().then((snapshot) async {
      if(snapshot.exists){
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", snapshot.data()!["email"]);
        await sharedPreferences!.setString("name", snapshot.data()!["name"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);

        List<String> userCartList = snapshot.data()!["userCart"].cast<String>();
        await sharedPreferences!.setStringList("userCart", userCartList);

        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      else{
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        showDialog(context: context, builder: (c){return ErrorDialog(message: "Please login with correct credentials.",);});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipPath(
            clipper: ClippingClass(),
            child: Container(
              color: const Color(0xfffb9e5a),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                  ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 90,),
                     child: Text("Please login to continue", style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                        letterSpacing: 3
                  ),
                  ),
                   ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30,),

          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.mail,
                  controller: emailController,
                  hintText: "Please enter Email Address",
                  isObsecure: false,
                ),

                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Please enter password",
                  isObsecure: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30,),

          ElevatedButton(
            onPressed: (){
              formValidation();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10), backgroundColor: const Color(0xfffb9e5a),),
            child: const Text("Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}

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

