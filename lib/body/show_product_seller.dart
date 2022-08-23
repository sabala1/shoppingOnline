import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/models/product.dart';
import 'package:shoppingonline/universes/constant.dart';
import 'package:shoppingonline/widgets/show_progress.dart';
import 'package:shoppingonline/widgets/show_title.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({super.key});

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/shoppingonline/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(apiGetProductWhereIdSeller).then(
      (value) {
        print('value ==>> $value');

        if (value.toString() == 'null') {
          //NO Data
          setState(() {
            load = false;
            haveData = false;
          });
        } else {
          //Have Data
          for (var item in json.decode(value.data)) {
            ProductModel model = ProductModel.fromMap(
              json.decode(value.data),
            );
            print('## name Product ==>> ${model.name}');

            setState(() {
              load = false;
              haveData = true;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? Text('Have Data')
              : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,                    
                    children: [
                      ShowTitle(
                        title: 'No Product',
                        textStyle: MyConstant().b3Style(),
                      ),
                    ],
                  ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.pinkdark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct),
        child: Text('Add'),
      ),
    );
  }
}
