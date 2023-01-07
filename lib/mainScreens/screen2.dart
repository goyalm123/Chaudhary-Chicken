import 'package:carousel_slider/carousel_slider.dart';
import 'package:chaudhary_chicken_users_app/widgets/category_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {

  // ArrayList to store the images for carousel
  final List <String> _carouselImages = [];
  var _dotPosition = 0;

  // Fetching the images from Firebase FireStore to carousel
  fetchCarouselImages() async {
    var firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestoreInstance.collection("carousel").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(qn.docs[i]["url"]);
        if (kDebugMode) {
          print(qn.docs[i]["url"]);
        }
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.all(8.0),
                child: CarouselSlider(
                  items: _carouselImages.map((item) =>
                      Padding(padding: const EdgeInsets.only(
                          top: 2, left: 4, right: 4, bottom: 1),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: NetworkImage(item),
                                fit: BoxFit.fill),),),)).toList(),
                  options: CarouselOptions(
                      viewportFraction: 0.8,
                      pauseAutoPlayOnManualNavigate: true,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                          milliseconds: 500),
                      autoPlayCurve: Curves.ease,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {
                          _dotPosition = val;
                        }
                        );
                      }
                  ),
                ),
              ),

              DotsIndicator(
                dotsCount: _carouselImages.isEmpty ? 1 : _carouselImages.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Colors.deepOrange,
                  spacing: const EdgeInsets.all(2),
                  activeSize: const Size(8, 8),
                  size: const Size(6, 6),
                  color: const Color(0xfffb9e5a).withOpacity(0.5),
                ),
              ),
              CategoryWidget()
            ],
          )
      ),
    );
  }
}