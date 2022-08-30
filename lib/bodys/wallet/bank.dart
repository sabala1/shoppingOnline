import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:shoppingonline/utillity/constant.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../../widgets/nav_confirm_wallet.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          buildTitle(),
          buildBKKbank(),
          buildKbank(),
        ],
      ),floatingActionButton: NavConfirmWallet(),
    );
  }

  Widget buildBKKbank() {
    return Container(
      height: 100,
      child: Center(
        child: Card(
          child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.indigo),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/bbl.svg'),
              ),
            ),
            title: ShowTitle(
              title: 'ธนาคาร xxxxxxxxxxxxx สาขา xxxxxxxxxxxxxxxxx',
              textStyle: MyConstant().b2Style(),
            ),
            subtitle: ShowTitle(
                title:
                    'ชื่อบัญชี xxxxxxxxxxxx xxxxxxxxxxx เลขที่ xxx- x- xxxxx',
                textStyle: MyConstant().b3Style()),
          ),
        ),
      ),
    );
  }

  Widget buildKbank() {
    return Container(
      height: 100,
      child: Center(
        child: Card(
          child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Colors.green.shade700),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/kbank.svg'),
              ),
            ),
            title: ShowTitle(
              title: 'ธนาคาร xxxxxxxxxx สาขา xxxxxxxxxxx',
              textStyle: MyConstant().b2Style(),
            ),
            subtitle: ShowTitle(
              title: 'ชื่อบัญชี xxxxxxxxxx xxxxxxxxx เลขที่ xxx- x- xxxxx',
              textStyle: MyConstant().b3Style(),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: ('การโอนเงินเข้าบัญชีธนาคาร'),
        textStyle: MyConstant().p1Style(),
      ),
    );
  }
}
