import 'package:flutter/material.dart';

class MyConstant {
  //General
  static String appName = 'Shopping Online';
  static String domain = 'https://7e2d-2405-9800-ba10-f0ca-483c-802f-5def-8a6.ngrok.io';
  
  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerervice = '/sellerService';
  static String routeRiderService = '/riderService';
  static String routeAddProduct = '/addProduct';

  //Image
  static String image1 = 'images/Delivery1.png';
  static String avatar = 'images/avatar.png';
  static String avatar1 = 'images/avatar1.png';

  //Color
  static Color primary = const Color(0xffe57373);
  static Color pinkdark = const Color(0xffaf4448);
  static Color pinklight = const Color(0xffffa4a2);
  static Color bluedark = const Color(0xff00227b);
  static Color bluelight = const Color(0xff3949ab);
  static Color blackdark = const Color(0xff000000);
  static Color errorvalidate = const Color(0xffFF0000);

  //Style
  TextStyle p1Style() => TextStyle(
    fontSize: 24,
    color: pinkdark,
    fontWeight: FontWeight.bold
  );
  TextStyle p2Style() => TextStyle(
    fontSize: 18,
    color: pinkdark,
    fontWeight: FontWeight.w700,
  );
  TextStyle p2whiteStyle() => const TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );
  TextStyle p3Style() => TextStyle(
    fontSize: 14,
    color: pinkdark,
    fontWeight: FontWeight.normal
  );
    TextStyle p3whiteStyle() => const TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.normal
  );
  TextStyle b2Style() => TextStyle(
    fontSize: 18,
    color: blackdark,
    fontWeight: FontWeight.w700,
  );
  TextStyle b3Style() => TextStyle(
    fontSize: 14,
    color: blackdark,
    fontWeight: FontWeight.normal,
  );

  ButtonStyle bg1Style () => ElevatedButton.styleFrom(
    backgroundColor: MyConstant.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
}