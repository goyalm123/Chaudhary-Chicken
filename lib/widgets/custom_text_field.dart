import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget
{
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecure = true;
  bool? enabled = true;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecure,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffb9e5a),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(1.0),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecure!,
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        decoration: InputDecoration(
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: Icon(
            data,
            color: Colors.black,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1,
                color: Colors.black54),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
