import 'package:chaudhary_chicken_users_app/models/menus.dart';
import 'package:chaudhary_chicken_users_app/widgets/categories_design.dart';
import 'package:chaudhary_chicken_users_app/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("sellers").doc("5wzmKHapUiMGAtQHozRAsqYCZDk2").collection("menus").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return circularProgress();
            }
            return SizedBox(
              height: 170,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('Categories', style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),),
                    ],
                  ),
                  Expanded(
                      child: InkWell(
                        onTap: (){},
                        splashColor: const Color(0xfffb9e5a),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {

                            Menus model = Menus.fromJson(snapshot.data!.docs[index].data()! as Map<String, dynamic>,);

                            return CategoriesDesign(
                              model: model,
                              context: context,
                            );
                          },
                        ),
                      ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}
