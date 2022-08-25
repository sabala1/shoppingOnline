import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingonline/widgets/show_title.dart';

import '../utillity/constant.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeAuthen, (route) => false),
                );
          },
          tileColor: MyConstant.bluedark,
          leading: const Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign Out',
            textStyle: MyConstant().p2whiteStyle(),
          ),
        ),
      ],
    );
  }
}