import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:shoppingonline/utillity/dialog.dart';
import 'package:shoppingonline/widgets/show_progress_circular.dart';

import '../../utillity/constant.dart';
import '../../widgets/nav_confirm_wallet.dart';
import '../../widgets/show_title.dart';

class Prompay extends StatefulWidget {
  const Prompay({super.key});

  @override
  State<Prompay> createState() => _PrompayState();
}

class _PrompayState extends State<Prompay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTitle(),
            buildCoryPrompay(),
            buildQRcode(),
            buildDownload(),
          ],
        ),
      ),floatingActionButton: NavConfirmWallet(),
    );
  }

  Row buildDownload() {
    double size = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          width: size * 0.55,
          height: 45,
          child: ElevatedButton(
            style: MyConstant().bg1Style(),
            onPressed: () async {
              String path = '/sdcard/download';
              try {
                await FileUtils.mkdir([path]);
                await Dio().download(MyConstant.urlPrompay, '$path/prompay.png').then(
                      (value) => MyDialog()
                          .normalDialog(context, 'Download Prompay Finish', ''),
                    );
              } catch (e) {
                MyDialog().normalDialog(context, 'Storage Permission Denied',
                      '');
              }
            },
            child: const Text(
              'Download QRcode',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Container buildQRcode() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
        imageUrl: MyConstant.urlPrompay,
        placeholder: (context, url) => ShowProgressCircular(),
      ),
    );
  }

  Widget buildCoryPrompay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          title: ShowTitle(
            title: '0xxxxxxxxxx',
            textStyle: MyConstant().b2Style(),
          ),
          subtitle: ShowTitle(
            title: 'บัญชี Prompay',
            textStyle: MyConstant().b3Style(),
          ),
          trailing: IconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: '0xxxxxxxxxx'),
              );
              MyDialog().normalDialog(
                  context, 'Copy QRcode Sucess', '');
            },
            icon: Icon(Icons.copy),
          ),
        ),
      ),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'ชำระเงินด้วย Prompay',
      textStyle: MyConstant().p1Style(),
    );
  }
}
