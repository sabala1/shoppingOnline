import 'package:flutter/material.dart';

class MyConstant {
  //General
  static String appName = 'Shopping Online';
  
  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerervice = '/sellerService';
  static String routeRiderService = '/riderService';

  //Image
  static String image1 = 'images/Delivery1.png';
  static String avatar = 'images/avatar.png';

  //Color
  static Color primary = const Color(0xffe57373);
  static Color dark = const Color(0xffaf4448);
  static Color light = const Color(0xffffa4a2);

  //Style
  TextStyle t1Style() => TextStyle(
    fontSize: 24,
    color: dark,
    fontWeight: FontWeight.bold
  );
  TextStyle t2Style() => TextStyle(
    fontSize: 18,
    color: dark,
    fontWeight: FontWeight.w700,
  );
  TextStyle t3Style() => TextStyle(
    fontSize: 14,
    color: dark,
    fontWeight: FontWeight.normal
  );

  ButtonStyle b1Style () => ElevatedButton.styleFrom(
    primary: MyConstant.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
}