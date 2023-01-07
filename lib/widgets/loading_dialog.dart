import 'package:chaudhary_chicken_users_app/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {

  final String? message;
  LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 15,),
          Text("${message!}, please Wait..."),
        ],
      ),
    );
  }
}