import 'package:chaudhary_chicken_users_app/global/global.dart';
import 'package:chaudhary_chicken_users_app/mainScreens/item_detail_screen.dart';
import 'package:flutter/material.dart';

import '../models/items.dart';

class ItemsDesignWidget extends StatefulWidget
{
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({super.key, this.model, this.context});

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailsScreen(model: widget.model)));
      },
      splashColor: myColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 261,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: myColor.withOpacity(0.8)
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 2.0,),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.model!.title!.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "Train",
                      ),
                    ),

                    Text(
                      "₹ ${widget.model!.price}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
