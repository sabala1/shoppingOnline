import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/models/product.dart';
import 'package:shoppingonline/pages/edit_product.dart';
import 'package:shoppingonline/universes/constant.dart';
import 'package:shoppingonline/widgets/show_img.dart';
import 'package:shoppingonline/widgets/show_progress_linear.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../widgets/show_progress_circular.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({super.key});

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (productModels.length != 0) {
      productModels.clear();
    } else {}
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
            ProductModel model = ProductModel.fromMap(item);
            print('## name Product ==>> ${model.name}');

            setState(() {
              load = false;
              haveData = true;
              productModels.add(model);
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: load
          ? ShowProgressLinear()
          : haveData!
              ? ListView.builder(
                  itemCount: productModels.length,
                  itemBuilder: (context, index) => Card(
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProduct(
                                    productModel: productModels[index],
                                  ),
                                ),
                              ).then((value) => loadValueFromAPI());
                            },
                            backgroundColor: MyConstant.pinklight,
                            foregroundColor: Colors.white,
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              confirmDialogDelete(productModels[index]);
                            },
                            backgroundColor: MyConstant.bluelight,
                            foregroundColor: Colors.white,
                            icon: Icons.delete_outline,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            width: size * 0.5 - 4,
                            height: size * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ShowTitle(
                                  title: productModels[index].name,
                                  textStyle: MyConstant().b2Style(),
                                ),
                                Container(
                                  width: size * 0.5,
                                  height: size * 0.4,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        createUrl(productModels[index].images),
                                    placeholder: (context, url) =>
                                        ShowProgressCircular(),
                                    errorWidget: (context, url, error) =>
                                        ShowImage(pathImage: MyConstant.image1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(4),
                            width: size * 0.5 - 4,
                            height: size * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShowTitle(
                                  title:
                                      'Price ${productModels[index].price} THB',
                                  textStyle: MyConstant().b2Style(),
                                ),
                                ShowTitle(
                                  title: productModels[index].detail,
                                  textStyle: MyConstant().b3Style(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
            Navigator.pushNamed(context, MyConstant.routeAddProduct).then(
          (value) => loadValueFromAPI(),
        ),
        child: Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/shoppingonline${strings[0]}';
    return url;
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: createUrl(productModel.images),
            placeholder: (context, url) => ShowProgressLinear(),
          ),
          title: ShowTitle(
            title: 'Delete ${productModel.name} ?',
            textStyle: MyConstant().b2Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## You Confrim Delete at id ==>> ${productModel.id}');
              String apiDeleteProductWhereId =
                  '${MyConstant.domain}/shoppingonline/deleteProductWhereId.php?isAdd=true&id=${productModel.id}';
              await Dio().get(apiDeleteProductWhereId).then(
                (value) {
                  Navigator.pop(context);
                  loadValueFromAPI();
                },
              );
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
