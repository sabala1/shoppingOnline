import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/models/user.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../bodys/shop_manage_seller.dart';
import '../bodys/show_oder_seller.dart';
import '../bodys/show_product_seller.dart';
import '../utillity/constant.dart';
import '../widgets/show_progress_linear.dart';
import '../widgets/show_signout.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    print('## id login ==>> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingonline/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then(
      (value) {
        print('## value ==>> $value');
        for (var item in json.decode(value.data)) {
          setState(
            () {
              userModel = UserModel.fromMap(item);
              print('## name logined ==>> ${userModel!.name}');

              widgets.add(
                ShowOrderSeller(),
              );
              widgets.add(ShopManageSeller(userModel: userModel!));
              widgets.add(
                ShowProductSeller(),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: const Text('Seller'),
      ),
      drawer: widgets.length == 0
          ? SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  ShowSignOut(),
                  Column(
                    children: [
                      buildHead(),
                      menuShowOrder(),
                      menuShopManage(),
                      menuShowProduct(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.length == 0 ? ShowProgressLinear() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
      otherAccountsPictures: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.face_outlined),
          iconSize: 36,
          color: MyConstant.light,
          tooltip: 'Edit Shop',
        ),
      ],
      decoration: BoxDecoration(
        color: MyConstant.bluelight,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(userModel == null
            ? 'Avatar ?'
            : '${MyConstant.domain}${userModel!.avatar}'),
      ),
      accountName: Text(userModel == null ? 'Name ?' : userModel!.name),
      accountEmail: Text(userModel == null ? 'Type ?' : userModel!.type),
    );
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Order',
        textStyle: MyConstant().b2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดของ Order ที่สั่ง',
        textStyle: MyConstant().b3Style(),
      ),
    );
  }

  ListTile menuShopManage() {
    return ListTile(
      onTap: () {
        setState(() {
          setState(() {
            indexWidget = 1;
            Navigator.pop(context);
          });
        });
      },
      leading: Icon(Icons.filter_2_outlined),
      title: ShowTitle(
        title: 'Shop Manage',
        textStyle: MyConstant().b2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดหน้าร้าน',
        textStyle: MyConstant().b3Style(),
      ),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          setState(() {
            indexWidget = 2;
            Navigator.pop(context);
          });
        });
      },
      leading: Icon(Icons.filter_3_outlined),
      title: ShowTitle(
        title: 'Show Product',
        textStyle: MyConstant().b2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดสินค้าที่ขาย',
        textStyle: MyConstant().b3Style(),
      ),
    );
  }
}
