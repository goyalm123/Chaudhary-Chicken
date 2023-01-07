import 'package:chaudhary_chicken_users_app/mainScreens/item_screen.dart';
import 'package:chaudhary_chicken_users_app/models/menus.dart';
import 'package:flutter/material.dart';

class CategoriesDesign extends StatefulWidget {

  Menus model;
  BuildContext? context;

  CategoriesDesign({required this.model, this.context});

  @override
  State<CategoriesDesign> createState() => _CategoriesDesignState();
}

class _CategoriesDesignState extends State<CategoriesDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: const Color(0xfffb9e5a),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xfffb9e5a),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.model.thumbnailUrl!,
                  height: 85,
                  width: 85,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 1,),
              Flexible(
                  child: Text(widget.model.menuTitle!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
