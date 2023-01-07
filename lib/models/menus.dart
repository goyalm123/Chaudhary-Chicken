import 'package:cloud_firestore/cloud_firestore.dart';

class Menus {
  String? menuId;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuId,
    this.menuInfo,
    this.menuTitle,
    this.publishedDate,
    this.sellerUID,
    this.status,
    this.thumbnailUrl,
  });

  Menus.fromJson(Map<String, dynamic> json){
    menuId = json["menuID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    publishedDate = json["publishedDate"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
    sellerUID = json["sellerUID"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menuID"] = menuId;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["status"] = status;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["sellerUID"] = sellerUID;

    return data;
  }


}