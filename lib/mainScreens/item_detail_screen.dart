import 'package:chaudhary_chicken_users_app/assistantMethods/cart_item_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
import '../assistantMethods/assistant_methods.dart';
import '../assistantMethods/total_amount.dart';
import '../global/global.dart';
import '../models/items.dart';
import '../widgets/cart_item_design.dart';
import '../widgets/progress_bar.dart';
import 'home_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen ({super.key, required this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {

  TextEditingController counterTextEditingController = TextEditingController();

  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantityList = separateItemQuantities();
  }

  _showModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 600,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xfffb9e5a).withOpacity(0.6),
                    blurRadius: 60,
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: CustomScrollView(
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
                          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
                                            primary: myColor,
                                            onPrimary: Colors.black
                                        ),
                                        icon: const Icon(Icons.clear_all),
                                        label: const Text("Clear")),
                                    ElevatedButton.icon(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                            primary: myColor,
                                            onPrimary: Colors.black
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
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model!.title.toString()),
        flexibleSpace: Container(decoration: const BoxDecoration(color: Color(0xfffb9e5a)),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white,),
                  onPressed: ()
                  {
                    //send user to cart screen
                    //Navigator.push(context, MaterialPageRoute(builder: (c) => const CartScreen(sellerUID: "5wzmKHapUiMGAtQHozRAsqYCZDk2")));
                    _showModalBottomSheet(context);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: 3,
                        right: 7,
                        child: Center(
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, c){
                              return Text(counter.count.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The product image
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.model!.thumbnailUrl.toString(),)),

            // The product name
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.model!.title.toString(),
                style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),),
            ),

            // The product description
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.model!.itemDescription.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),),
            ),

            // The increment and decrement button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberInputPrefabbed.roundedButtons(
                  controller: counterTextEditingController,
                incDecBgColor: const Color(0xfffb9e5a),
                min: 1,
                max: 99,

                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
                separateIcons: false,
              ),
            ),

            const SizedBox(height: 20,),

            // The price of the product
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("₹ ${widget.model!.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),),
            ),

            // The add to cart button
            Center(
              child: InkWell(
                onTap: (){

                  int itemCounter = int.parse(counterTextEditingController.text);

                  List<String> separateItemIDsList = separateItemIDs();

                  // Check if the product is already in the cart
                  separateItemIDsList.contains(widget.model!.itemID)
                  ? Fluttertoast.showToast(msg: "Item is already in the cart") :
                  // Add to cart
                  addItemToCart(widget.model!.itemID, context, itemCounter);

                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xfffb9e5a).withOpacity(0.6)
                  ),
                  width: MediaQuery.of(context).size.width - 15,
                  height: 40,
                  child: const Center(
                    child: Text("Add to cart", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
