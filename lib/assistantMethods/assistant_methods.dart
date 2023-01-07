import 'package:chaudhary_chicken_users_app/global/global.dart';
import 'package:chaudhary_chicken_users_app/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'cart_item_counter.dart';

separateItemIDs(){
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("This is the item Id now: $getItemId");

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Items List now: $separateItemIDsList");
  return separateItemIDsList;
}

addItemToCart(String? foodItemId, BuildContext context, int itemCounter){
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add("${foodItemId!}:$itemCounter");
  
  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({
        "userCart": tempList

  }).then((value) {
    
    Fluttertoast.showToast(msg: "Item added successfully");
    sharedPreferences!.setStringList("userCart", tempList);

    // update the cart number
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });
}

separateItemQuantities(){

  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {

    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nThis is the quantity number = $quanNumber");

    separateItemQuantityList.add(quanNumber);
  }

  print("\nThis is Quantity List now: $separateItemQuantityList");
  return separateItemQuantityList;
}

clearCartNow(context){
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList})
      .then((value) {
        sharedPreferences!.setStringList("userCart", emptyList!);
        Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();

  });
}