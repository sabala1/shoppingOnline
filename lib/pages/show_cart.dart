import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingonline/models/sqlite.dart';
import 'package:shoppingonline/utillity/sqlite.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../models/user.dart';
import '../utillity/constant.dart';
import '../widgets/show_progress_linear.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({super.key});

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModels;
  int? total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQLite();
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }
    await SQLite().readSQLite().then((value) {
      setState(() {
        load = false;
        sqliteModels = value;
        findDetailSeller();
        calculateTotal();
      });
    });
  }

  void calculateTotal() async {
    for (var item in sqliteModels) {
      int sumInt = int.parse(item.sum.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<void> findDetailSeller() async {
    String idSeller = sqliteModels[0].idSeller;
    print('## idSeller ==>> $idSeller');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingonline/getUserWhereId.php?isAdd=true&id=$idSeller';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModels = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: MyConstant.primary,
      ),
      body: load
          ? ShowProgressLinear()
          : sqliteModels.isEmpty
              ? Center(
                  child: ShowTitle(
                    title: 'Empty cart',
                    textStyle: MyConstant().b3Style(),
                  ),
                )
              : buildContant(),
    );
  }

  Column buildContant() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShowSeller(),
        builHead(),
        listProduct(),
        Divider(
          color: MyConstant.grey,
        ),
        buildTotal(),
        Divider(
          color: MyConstant.grey,
        ),
        buildButtonController(),
      ],
    );
  }

  Future<void> confirmDeleteAll() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowTitle(
            title: 'คุณต้องการลบสินค้าทั้งหมดในตระกร้าหรือไหม',
            textStyle: MyConstant().b2Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await SQLite().emptySQLite().then((value) {
                Navigator.pop(context);
                processReadSQLite();
              });
            },
            child: Text('ลบ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  Row buildButtonController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, MyConstant.addWallet);
          },
          child: Text('Order'),
        ),
        Container(
          margin: EdgeInsets.only(left: 4, right: 8),
          child: ElevatedButton(
            onPressed: () => confirmDeleteAll(),
            child: Text('Delete All'),
          ),
        ),
      ],
    );
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTitle(
                title: 'Total : ',
                textStyle: MyConstant().p2Style(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ShowTitle(
            title: total == null ? '' : total.toString(),
            textStyle: MyConstant().b2Style(),
          ),
        ),
      ],
    );
  }

  ListView listProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: ((context, index) => Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ShowTitle(
                    title: sqliteModels[index].name,
                    textStyle: MyConstant().b3Style(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowTitle(
                  title: sqliteModels[index].price,
                  textStyle: MyConstant().b3Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowTitle(
                  title: sqliteModels[index].amount,
                  textStyle: MyConstant().b3Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowTitle(
                  title: sqliteModels[index].sum,
                  textStyle: MyConstant().b3Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () async {
                    int idSQLite = sqliteModels[index].id!;
                    await SQLite().deleteSQLiteWhereId(idSQLite).then(
                          (value) => (value) => processReadSQLite(),
                        );
                  },
                  icon: Icon(Icons.delete_forever),
                  color: MyConstant.errorvalidate,
                ),
              ),
            ],
          )),
    );
  }

  Container builHead() {
    return Container(
      decoration: BoxDecoration(color: MyConstant.bluelight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ShowTitle(
                  title: 'Product',
                  textStyle: MyConstant().p2whiteStyle(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Price',
                textStyle: MyConstant().p2whiteStyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Amt.',
                textStyle: MyConstant().p2whiteStyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Sum',
                textStyle: MyConstant().p2whiteStyle(),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Padding ShowSeller() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: userModels == null ? '' : userModels!.name,
        textStyle: MyConstant().p1Style(),
      ),
    );
  }
}
