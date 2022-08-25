import 'package:flutter/material.dart';
import '../utillity/constant.dart';
import '../widgets/show_signout.dart';

class RiderService extends StatefulWidget {
  const RiderService({ Key? key }) : super(key: key);

  @override
  State<RiderService> createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: const Text('Rider'),
      ),
      drawer: const Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}