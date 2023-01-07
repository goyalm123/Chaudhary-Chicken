import 'package:flutter/material.dart';

import '../global/global.dart';
import '../models/items.dart';

class CartItemDesign extends StatefulWidget {

  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({super.key,
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
        child: SizedBox(
          height: 95,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: myColor.withOpacity(0.3)
            ),
            child: Row(
              children: [
                //image
                Image.network(widget.model!.thumbnailUrl!, width: 140, height: 200, fit: BoxFit.cover,),

                const SizedBox(width: 10,),
                //title
                //quantity number
                //price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //title
                    Text(
                      widget.model!.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),

                    //quantity number // x 7
                    Row(
                      children: [
                        const Text(
                          "x",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          widget.quanNumber.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),

                    //price
                    Row(
                      children: [
                        const Text(
                          "Price: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          "₹ ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0
                          ),
                        ),
                        Text(
                            widget.model!.price.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
