import 'package:flutter/material.dart';
import 'package:shoppingonline/universes/constant.dart';
import 'package:shoppingonline/pages/authen.dart';
import 'package:shoppingonline/pages/buyer_ser.dart';
import 'package:shoppingonline/pages/create_acc.dart';
import 'package:shoppingonline/pages/rider_ser.dart';
import 'package:shoppingonline/pages/seller_ser.dart';


final Map<String, WidgetBuilder> map = {
  '/authen':(contex) => const Authen(),
  '/createAccount':(context) => const CreateAccount(),
  '/buyerService':(context) => const BuyerService(),
  '/sellerService':(context) => const SellerService(),
  '/riderService':(context) => const RiderService(),
}; 

String? initalRoute;

void main(){
  initalRoute = Constant.routeAuthen;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constant.appName,
      routes: map,
      initialRoute: initalRoute,
    );
  }
}