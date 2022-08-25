import 'package:flutter/material.dart';

import '../utillity/constant.dart';
import '../widgets/show_signout.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: const Text('Buyer'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}
