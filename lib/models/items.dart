import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  String? thumbnailUrl;
  String? itemDescription;
  String? status;
  int? price;
  Timestamp? publishedDate;

  Items({
    this.menuID,
    this.sellerUID,
    this.thumbnailUrl,
    this.publishedDate,
    this.status,
    this.title,
    this.itemDescription,
    this.itemID,
    this.price,
    this.shortInfo,
  });

  Items.fromJson(Map<String, dynamic> json)
  {
    menuID = json['menuID'];
    sellerUID = json['sellerUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    itemDescription = json['itemDescription'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuID'] = menuID;
    data['sellerUID'] = sellerUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['price'] = price;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['itemDescription'] = itemDescription;
    data['status'] = status;

    return data;
  }
}