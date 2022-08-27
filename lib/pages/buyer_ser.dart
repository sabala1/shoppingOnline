import 'package:flutter/material.dart';
import 'package:shoppingonline/bodys/buyer/show_all_shop_buyer.dart';
import 'package:shoppingonline/bodys/buyer/show_order_buyer.dart';
import 'package:shoppingonline/bodys/buyer/show_wallet_buyer.dart';

import '../utillity/constant.dart';
import '../widgets/show_progress_linear.dart';
import '../widgets/show_signout.dart';
import '../widgets/show_title.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> widgets = [
    ShowAllShopBuyer(),
    ShowWalletBuyer(),
    ShowOrderBuyer()
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, MyConstant.showCart),
            icon: Icon(Icons.shopping_cart_outlined),
          ),
        ],
        backgroundColor: MyConstant.primary,
        title: const Text('Buyer'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHead(),
                showAllShop(),
                myWallet(),
                myOrder(),
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: widgets.length == 0 ? ShowProgressLinear() : widgets[indexWidget],
    );
  }

  ListTile showAllShop() {
    return ListTile(
      leading: Icon(Icons.shopping_bag_outlined),
      title: ShowTitle(
        title: 'Show All Shop',
        textStyle: MyConstant().b2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดของร้านค้าทั้งหมด',
        textStyle: MyConstant().b3Style(),
      ),
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile myWallet() {
    return ListTile(
      leading: Icon(Icons.money),
      title: ShowTitle(
        title: 'My Wallet',
        textStyle: MyConstant().b2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงจำนวนเงินที่มี',
        textStyle: MyConstant().b3Style(),
      ),
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile myOrder() {
    return ListTile(
      leading: Icon(Icons.list),
      title: ShowTitle(
        title: 'Order',
        textStyle: MyConstant().b2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดของ Order ที่สั่ง',
        textStyle: MyConstant().b3Style(),
      ),
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
    );
  }

  UserAccountsDrawerHeader buildHead() =>
      UserAccountsDrawerHeader(accountName: null, accountEmail: null);
}
