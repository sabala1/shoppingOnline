import 'package:flutter/material.dart';

class MyConstant {
  //General
  static String appName = 'Shopping Online';
  static String domain = 'https://7e2d-2405-9800-ba10-f0ca-483c-802f-5def-8a6.ngrok.io';
  static String urlPrompay = 'https://promptpay.io/0843030416.png';
  static String publicKey = 'pkey_test_5syl93u1qfq1btynh64';
  static String secreKey = 'skey_test_5syl8ttulf3xr6mj1lw';

  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerervice = '/sellerService';
  static String routeRiderService = '/riderService';
  static String routeAddProduct = '/addProduct';
  static String routeEditProfileSeller = '/editProfileSeller';
  static String routeShowCart= '/showCart';
  static String routeaddWallet = '/addWallet';
  static String routeConfirmAddWallet = '/confirmAddWallet';

  //Image
  static String image1 = 'images/Delivery1.png';
  static String avatar = 'images/avatar.png';
  static String avatar1 = 'images/avatar1.png';
  static String logo = 'images/logo.jpg';

  //Color
  static Color primary = const Color(0xffe57373);
  static Color pinkdark = const Color(0xffaf4448);
  static Color pinklight = const Color(0xffffa4a2);
  static Color bluedark = const Color(0xff00227b);
  static Color bluelight = const Color(0xff3949ab);
  static Color dark = const Color(0xff000000);
  static Color light = const Color(0xffffffff);
  static Color grey = const Color(0xff6d6d6d);
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
  TextStyle p2whiteStyle() => TextStyle(
    fontSize: 18,
    color: light,
    fontWeight: FontWeight.w700,
  );
  TextStyle p3Style() => TextStyle(
    fontSize: 14,
    color: pinkdark,
    fontWeight: FontWeight.normal
  );
  TextStyle p3whiteStyle() => TextStyle(
    fontSize: 14,
    color: light,
    fontWeight: FontWeight.normal
  );
  TextStyle b2Style() => TextStyle(
    fontSize: 18,
    color: dark,
    fontWeight: FontWeight.w700,
  );
  TextStyle b2NorStyle() => TextStyle(
    fontSize: 18,
    color: dark,
    fontWeight: FontWeight.normal,
  );
  TextStyle b3Style() => TextStyle(
    fontSize: 14,
    color: dark,
    fontWeight: FontWeight.normal,
  );
  TextStyle g2Style() => TextStyle(
    fontSize: 18,
    color: grey,
    fontWeight: FontWeight.normal,
  );

  ButtonStyle bg1Style () => ElevatedButton.styleFrom(
    backgroundColor: MyConstant.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
}