import 'package:flutter/material.dart';

circularProgress(){
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 10),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
          Color(0xfffb9e5a)
      ),
    ),
  );
}