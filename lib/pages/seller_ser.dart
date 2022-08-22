import 'package:flutter/material.dart';

import '../universes/Constant.dart';
import '../widgets/show_signout.dart';

class SellerService extends StatefulWidget {
  const SellerService({ Key? key }) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: const Text('Seller'),
      ),
      drawer: const Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}