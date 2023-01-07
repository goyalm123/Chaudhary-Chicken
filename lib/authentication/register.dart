import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String userImageUrl = "";

  Future <void> _getImage() async{
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  // Validating the registration form that all fields are properly filled.
  // If any field is not meeting the requirements, the dialog box will appear.
  Future<void> formValidation() async{
    if (imageXFile == null){
      showDialog(
          context: context,
          builder: (c){return ErrorDialog(message: "Please select an image",);
          });
    }
    else {
      // Nested if condition
      if (passwordController.text == confirmPasswordController.text){
        if (confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty){
          //uploading the image to the firebase
          showDialog(
              context: context,
              builder: (c){return LoadingDialog(message: "Registering",);});
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            userImageUrl = url;

            // Authenticating the user with Firebase stored credentials.
            authenticateSellerandSignUp();
          });
        }
        else{
          showDialog(
              context: context,
              builder: (c){return ErrorDialog(message: "All fields are mandatory",);
              });
        }
      }
      else {
        showDialog(
            context: context,
            builder: (c){return ErrorDialog(message: "Password do not match",);
            });
      }
    }
  }

  // Saving the data to the Firebase FireStore
  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photoUrl": userImageUrl,
      "status": "approved",
      "userCart": ['garbageValue'],
    });

    // Saving the data to the User's device locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", userImageUrl);
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
    // We can save more information locally
  }

  // Authenticating the user with the firebase and then sending them to HomeScreen
  void authenticateSellerandSignUp() async {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
    .then((auth) {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){return ErrorDialog(message: error.message.toString());
          });
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                      child: Text("Please register to continue", style: TextStyle(
                          fontSize: 24,
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
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){_getImage();},
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: const Color(0xfffb9e5a),
                backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile==null ? Icon(Icons.add_photo_alternate, size: MediaQuery.of(context).size.width * 0.20, color: Colors.black,) : null,
              ),
            ),
            const SizedBox(height: 20,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Please enter your name",
                    isObsecure: false,
                  ),

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

                  CustomTextField(
                    data: Icons.lock_person,
                    controller: confirmPasswordController,
                    hintText: "Please confirm password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
                onPressed: (){formValidation();},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10), backgroundColor: const Color(0xfffb9e5a),),
                child: const Text("Register", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
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