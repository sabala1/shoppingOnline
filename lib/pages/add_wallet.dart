import "package:flutter/material.dart";
import 'package:shoppingonline/bodys/wallet/bank.dart';
import 'package:shoppingonline/bodys/wallet/credit.dart';
import 'package:shoppingonline/bodys/wallet/prompay.dart';
import 'package:shoppingonline/utillity/constant.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  List<Widget> widgets = [
    Bank(),
    Prompay(),
    Credit(),
  ];
  List<IconData> icons = [Icons.money, Icons.book, Icons.credit_card];
  List<String> titles = ['Bank', 'Prompay', 'Credit'];
  int indexPosition = 0;
  List<BottomNavigationBarItem> BottomNavigationBarItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int i = 0;

    for (var item in titles) {
      BottomNavigationBarItems.add(
        createBottomNivigationBarItem(icons[i], item),
      );
      i++;
    }
  }

  BottomNavigationBarItem createBottomNivigationBarItem(
          IconData iconData, String string) =>
      BottomNavigationBarItem(icon: Icon(iconData), label: string);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text('Wallet'),
      ),
      body: widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: MyConstant.bluedark),
        unselectedIconTheme: IconThemeData(color: MyConstant.pinklight),
        items: BottomNavigationBarItems,
        currentIndex: indexPosition,
        onTap: (value) {
          setState(() {
            indexPosition = value;
          });
        },
      ),
    );
  }
}
