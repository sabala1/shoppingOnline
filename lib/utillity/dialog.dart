import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shoppingonline/utillity/constant.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_title.dart';

class MyDialog {
  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(
            pathImage: MyConstant.image1,
          ),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().p1Style(),
          ),
          subtitle: ShowTitle(
            title: message,
            textStyle: MyConstant().p3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(
            pathImage: MyConstant.image1,
          ),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().p2Style(),
          ),
          subtitle: ShowTitle(
            title: message,
            textStyle: MyConstant().p3Style(),
          ),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Null> showProcressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: LinearProgressIndicator(
                color: MyConstant.bluelight,
              ),
            ),
          ),
          onWillPop: () async {
            return false;
          }),
    );
  }
}
