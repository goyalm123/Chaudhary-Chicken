import 'package:chaudhary_chicken_users_app/assistantMethods/cart_item_counter.dart';
import 'package:chaudhary_chicken_users_app/assistantMethods/total_amount.dart';
import 'package:chaudhary_chicken_users_app/global/global.dart';
import 'package:chaudhary_chicken_users_app/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../assistantMethods/assistant_methods.dart';
import '../models/items.dart';
import '../widgets/cart_item_design.dart';
import '../widgets/progress_bar.dart';

class CartScreen extends StatefulWidget
{
  final String? sellerUID;

  const CartScreen({super.key, this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
{

  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xfffb9e5a)),
        ),
        title: const Text(
          "Cart",
        ),
      ),

      body: CustomScrollView(
        slivers: [
          // Fetching the data from the database
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data!.docs.isEmpty
                  ? //startBuildingCart()
                    Container()
                  : SliverList(delegate: SliverChildBuilderDelegate((context, index){
                    Items model = Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );

                    if(index == 0){
                      totalAmount = 0;
                      totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                    }else{
                      totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                    }

                    if(snapshot.data!.docs.length - 1 == index){
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                      });
                    }

                    return CartItemDesign(
                      model: model,
                      context: context,
                      quanNumber: separateItemQuantityList![index],
                    );
                    },
                childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                    ),
                  );
              },
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfffb9e5a).withOpacity(0.7),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                width: double.infinity,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                  child: Column(
                    children: [
                      Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c){
                        return Center(
                          child: cartProvider.count == 0
                              ? const Text("Please add something in the cart", style: TextStyle(fontSize: 18))
                              : Text("The total amount is: ₹${amountProvider.tAmount.toString()}", style: const TextStyle(fontSize: 18)),
                        );
                      }),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                              onPressed: (){
                                clearCartNow(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
                                Fluttertoast.showToast(msg: "Cart cleared");
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black, backgroundColor: myColor
                              ),
                              icon: const Icon(Icons.clear_all),
                              label: const Text("Clear")),
                          ElevatedButton.icon(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: myColor
                              ),
                              icon: const Icon(Icons.navigate_next),
                              label: const Text("Checkout")),
                        ],
                      )
                    ],
                  ),
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
