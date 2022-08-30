import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoppingonline/utillity/constant.dart';
import 'package:shoppingonline/widgets/show_title.dart';

class NavConfirmWallet extends StatefulWidget {
  const NavConfirmWallet({super.key});

  @override
  State<NavConfirmWallet> createState() => _NavConfirmWalletState();
}

class _NavConfirmWalletState extends State<NavConfirmWallet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      //height: 80,
      child: InkWell(
        onTap: () => Navigator.pushNamedAndRemoveUntil(
          context,
          MyConstant.routeConfirmAddWallet,
          (route) => false,
        ),
        child: Card(
          color: MyConstant.bluelight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/bill.png',
                  color: MyConstant.light,
                ),
                ShowTitle(
                    title: 'Confirm', textStyle: MyConstant().p3whiteStyle())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
