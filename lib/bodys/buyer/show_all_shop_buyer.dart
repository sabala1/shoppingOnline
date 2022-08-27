import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingonline/pages/show_producr_buyer.dart';
import 'package:shoppingonline/bodys/seller/show_product_seller.dart';
import 'package:shoppingonline/models/user.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_progress_circular.dart';
import 'package:shoppingonline/widgets/show_progress_linear.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../../utillity/constant.dart';

class ShowAllShopBuyer extends StatefulWidget {
  const ShowAllShopBuyer({super.key});

  @override
  State<ShowAllShopBuyer> createState() => _ShowAllShopBuyerState();
}

class _ShowAllShopBuyerState extends State<ShowAllShopBuyer> {
  bool load = true;
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    String apiGetUserWhereSeller =
        '${MyConstant.domain}/shoppingonline/getUserWhereSeller.php';
    await Dio().get(apiGetUserWhereSeller).then(
      (value) {
        setState(() {
          load = false;
        });
        print('value ==> ${value}');
        var loadValueFromAPI = json.decode(value.data);
        for (var item in loadValueFromAPI) {
          //print('item ==>> $item');
          UserModel model = UserModel.fromMap(item);
          //print('name ==>> ${model.name}');

          setState(() {
            userModels.add(model);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: load
          ? ShowProgressLinear()
          : GridView.builder(
              itemCount: userModels.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 2 / 3, maxCrossAxisExtent: 160),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('You click from ${userModels[index].name}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowProductBuyer(userModels: userModels[index]),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        child: CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                ShowImage(pathImage: MyConstant.avatar),
                            placeholder: (context, url) =>
                                ShowProgressCircular(),
                            fit: BoxFit.cover,
                            imageUrl:
                                '${MyConstant.domain}${userModels[index].avatar}'),
                      ),
                      ShowTitle(
                        title: cutWord(userModels[index].name),
                        textStyle: MyConstant().b3Style(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 45) {
      result = result.substring(0, 44);
      result = '$result...';
    }
    return result;
  }
}
