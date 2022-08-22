import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/pages/add_product.dart';
import 'package:shoppingonline/universes/Constant.dart';
import 'package:shoppingonline/pages/authen.dart';
import 'package:shoppingonline/pages/buyer_ser.dart';
import 'package:shoppingonline/pages/create_acc.dart';
import 'package:shoppingonline/pages/rider_ser.dart';
import 'package:shoppingonline/pages/seller_ser.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (contex) => const Authen(),
  '/createAccount': (context) => const CreateAccount(),
  '/buyerService': (context) => const BuyerService(),
  '/sellerService': (context) => const SellerService(),
  '/riderService': (context) => const RiderService(),
  '/addProduct': (contex) => const AddProduct(),
};

String? initalRoute;

//หา preferences ให้เจอก่อน เพื่อ navigator หน้าต่างๆ
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('## type ==>> $type');
  if (type?.isEmpty ?? true) {
    initalRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initalRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initalRoute = MyConstant.routeSellerervice;
        runApp(MyApp());
        break;
      case 'rider':
        initalRoute = MyConstant.routeRiderService;
        runApp(MyApp());
        break;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initalRoute,
    );
  }
}
