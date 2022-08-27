import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingonline/models/product.dart';
import 'package:shoppingonline/models/user.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_progress_circular.dart';
import 'package:shoppingonline/widgets/show_progress_linear.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../models/sqlite.dart';
import '../utillity/constant.dart';
import '../utillity/dialog.dart';
import '../utillity/sqlite.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModels;
  const ShowProductBuyer({super.key, required this.userModels});

  @override
  State<ShowProductBuyer> createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModels;
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];
  int amountInt = 1;
  String? currentIdSeller;

  @override
  void initState() {
    super.initState();
    userModels = widget.userModels;
    loadValueFromAPI();
    loadCart();
  }

  Future<Null> loadCart() async {
    await SQLite().readSQLite().then((value) {
      if(value.length != 0) {
        List<SQLiteModel> models = [];
        for (var model in value) {
          models.add(model);
        }
        currentIdSeller = models[0].idSeller;
      }
    });
  }

  Future<Null> loadValueFromAPI() async {
    String apiGetProductWhereSeller =
        '${MyConstant.domain}/shoppingonline/getProductWhereIdSeller.php?isAdd=true&idSeller=${userModels!.id}';
    await Dio().get(apiGetProductWhereSeller).then(
      (value) {
        print('## value ==>> $value');

        if (value.toString() == 'null') {
          setState(() {
            load = false;
            haveData = false;
          });
        } else {
          for (var item in json.decode(value.data)) {
            ProductModel models = ProductModel.fromMap(item);

            setState(() {
              load = false;
              haveData = true;
              productModels.add(models);
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(userModels!.name),
        backgroundColor: MyConstant.primary,
      ),
      body: load
          ? ShowProgressLinear()
          : haveData!
              ? buildListProduct()
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
    );
  }

  LayoutBuilder buildListProduct() {
    return LayoutBuilder(
        builder: (context, constant) => ListView.builder(
              itemCount: productModels.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('## You Click Index ==>> $index');
                  showAlertDialog(
                    productModels[index],
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      Container(
                        width: constant.maxWidth * 0.4,
                        height: constant.maxWidth * 0.4,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => ShowProgressCircular(),
                          errorWidget: ((context, url, error) =>
                              ShowImage(pathImage: MyConstant.avatar1)),
                          imageUrl: findeUrlImage(
                            productModels[index].images,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShowTitle(
                              title: productModels[index].name,
                              textStyle: MyConstant().b2Style(),
                            ),
                            ShowTitle(
                              title: 'ราคา ${productModels[index].price} บาท',
                              textStyle: MyConstant().b3Style(),
                            ),
                            ShowTitle(
                              title:
                                  'รายละเอียด : ${productModels[index].detail}',
                              textStyle: MyConstant().b3Style(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  String findeUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');

    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/shoppingonline${strings[0]}';
    print('## result ==>> $result');
    return result;
  }

  Future<Null> showAlertDialog(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: ListTile(
            title: ShowTitle(
              title: productModel.name,
              textStyle: MyConstant().b2Style(),
            ),
            subtitle: ShowTitle(
              title: 'ราคา ${productModel.price} บาท',
              textStyle: MyConstant().b3Style(),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      if (amountInt != 1) {
                        setState(() {
                          amountInt--;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: MyConstant.dark,
                    ),
                  ),
                  ShowTitle(
                    title: amountInt.toString(),
                    textStyle: MyConstant().b2Style(),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        amountInt++;
                      });
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: MyConstant.dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    String idSeller = userModels!.id;
                    String idProduct = productModel.id;
                    String name = productModel.name;
                    String price = productModel.price;
                    String amount = amountInt.toString();
                    int sumInt = int.parse(price) * amountInt;
                    String sum = sumInt.toString();

                    print(
                        '### curentIdSeller = $currentIdSeller, idSeller ==>> $idSeller, idProduct = $idProduct, name = $name, price = $price, amount = $amount, sum = $sum');

                    if ((currentIdSeller == idSeller) ||
                        (currentIdSeller == null)) {
                      SQLiteModel sqLiteModel = SQLiteModel(
                          idSeller: idSeller,
                          idProduct: idProduct,
                          name: name,
                          price: price,
                          amount: amount,
                          sum: sum);
                      await SQLite()
                          .insertValueToSQLite(sqLiteModel)
                          .then((value) {
                        amountInt = 1;
                        Navigator.pop(context);
                      });
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      MyDialog().normalDialog(context, 'ร้านผิด ?',
                          'กรุณาเลือกสินค้าที่ ร้านเดิม ให้เสร็จก่อน เลือกร้านอื่น');
                    }
                  },
                  child: Text(
                    'Add Cart',
                    style: MyConstant().p2Style(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //Navigator.pop(context);
                   
                  },
                  child: Text(
                    'Cancel',
                    style: MyConstant().b2NorStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
