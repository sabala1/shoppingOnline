import 'dart:convert';
import 'dart:ffi';

import "package:flutter/material.dart";
import 'package:omise_flutter/omise_flutter.dart';
import 'package:shoppingonline/utillity/constant.dart';
import 'package:shoppingonline/widgets/show_title.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import '../../utillity/dialog.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});

  @override
  State<Credit> createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  String? name,
      surname,
      idCard,
      expiryDateMouth,
      expiryDateYear,
      cvc,
      amount,
      expriyDateStr;
  MaskTextInputFormatter idCardMask =
      MaskTextInputFormatter(mask: '#### - #### - #### - ####');
  MaskTextInputFormatter expiryDateMask =
      MaskTextInputFormatter(mask: '## / ####');
  MaskTextInputFormatter cvcMask = MaskTextInputFormatter(mask: '###');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleMain('ชำระเงินด้วย Credit Crad'),
                buildTitle('Name Surname'),
                buildNameSur(),
                buildTitle('ID Card'),
                formIDcard(),
                buildEXPcvc(),
                buildTitle('Amount'),
                formAmount(),
                buildElevatedButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getTokenAndChargeOmise() async {
    String publicKey = MyConstant.publicKey;

    print(
        'name ==>> $name, surname ==>> $surname, publicKey ==>> $publicKey, idCard ==>> $idCard, expiryDataStr ==>> $expriyDateStr, expiryDateMouth ==>> $expiryDateMouth, expiryDatyYear ==>> $expiryDateYear, cvc ==>>> $cvc',);

    OmiseFlutter omiseFlutter = OmiseFlutter(publicKey);
    await omiseFlutter.token
        .create(
            '$name $surname', idCard!, expiryDateMouth!, expiryDateYear!, cvc!)
        .then((value) async {
      String token = value.id.toString();
      print('token ==>> $token');

      String secreKey = MyConstant.secreKey;
      String urlAPI = 'https://api.omise.co/charges';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode(secreKey + ":"));

      Map<String, String> headerMap = {};
      headerMap['authorization'] = basicAuth;
      headerMap['Cache-Control'] = 'no-cache';
      headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

      String zero = '00';
      amount = '$amount$zero';
      print('amount00 ==>> $amount');

      Map<String, dynamic> data = {};
      data['amount'] = amount;
      data['currency'] = 'thb';
      data['card'] = token;

      Uri uri = Uri.parse(urlAPI);

      http.Response response = await http.post(
        uri,
        headers: headerMap,
        body: data,
      );

      var resultCharge = json.decode(response.body);
      // print('resultCharge = $resultCharge');
      print('status ของการตัดบัตร ==>> ${resultCharge['status']}');
    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      MyDialog().normalDialog(context, title, message);
    });
  }

  Row buildElevatedButton(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 45,
          child: ElevatedButton(
            style: MyConstant().bg1Style(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                getTokenAndChargeOmise();
              }
            },
            child: const Text(
              'Add CreditCard',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget formAmount() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else {
            amount = value.trim();
            print('Amount ==>> $amount');
            return null;
          }
        },
        decoration: InputDecoration(
          suffix: ShowTitle(
            title: 'THB',
            textStyle: MyConstant().b2Style(),
          ),
          labelStyle: MyConstant().p3Style(),
          hintText: 'Amount',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinkdark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinklight),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Column buildEXPcvc() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildTitle('Expiry Date'),
            ),
            Expanded(
              child: buildTitle('CVC'),
            ),
          ],
        ),
        Row(
          children: [
            buildSizeBox(30),
            Expanded(
              child: formExpiry(),
            ),
            buildSizeBox(8),
            Expanded(
              child: formCVC(),
            ),
            buildSizeBox(30),
          ],
        ),
      ],
    );
  }

  Container buildNameSur() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          buildSizeBox(30),
          formName(),
          buildSizeBox(8),
          formSurName(),
          buildSizeBox(30),
        ],
      ),
    );
  }

  SizedBox buildSizeBox(double width) => SizedBox(
        width: width,
      );

  Widget formName() {
    return Expanded(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else {
            name = value.trim();
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().p3Style(),
          hintText: 'Name',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinkdark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinklight),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget formSurName() {
    return Expanded(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else {
            surname = value.trim();
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().p3Style(),
          hintText: 'SurName',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinkdark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinklight),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget formIDcard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        inputFormatters: [idCardMask],
        onChanged: ((value) {
          idCard = idCardMask.getUnmaskedText();
        }),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else {
            if (idCard!.length != 16) {
              return 'ID Card ต้องมี 16 ตัวอักษร';
            } else {
              return null;
            }
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().p3Style(),
          hintText: 'XXXX-XXXX-XXXX-XXXX',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinkdark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinklight),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget formExpiry() {
    return Expanded(
      child: TextFormField(
        inputFormatters: [expiryDateMask],
        keyboardType: TextInputType.number,
        onChanged: (value) {
          expriyDateStr = expiryDateMask.getUnmaskedText();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else {
            if (expriyDateStr!.length != 6) {
              return 'กรุณากรอกให้ครบ';
            } else {
              expiryDateMouth = expriyDateStr!.substring(0, 2);
              expiryDateYear = expriyDateStr!.substring(2, 6);

              int expiryDateMouthInt = int.parse(expiryDateMouth!);
              expiryDateMouth = expiryDateMouthInt.toString();

              if (expiryDateMouthInt > 12) {
                return 'เดือนไม่ควรเกิน 12';
              } else {
                return null;
              }
            }
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().p3Style(),
          hintText: 'XX/XXXX',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinkdark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinklight),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget formCVC() {
    return Expanded(
      child: TextFormField(
        inputFormatters: [cvcMask],
        keyboardType: TextInputType.number,
        onChanged: (value) {
          cvc = cvcMask.getUnmaskedText();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required.';
          } else {
            if (expriyDateStr!.length != 6) {
              return 'กรุณากรอกให้ครบ';
            }
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().p3Style(),
          hintText: 'XXX',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinkdark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.pinklight),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.errorvalidate),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String title) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShowTitle(
          title: title,
          textStyle: MyConstant().b2Style(),
        ),
      );

  Widget buildTitleMain(String title) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowTitle(
            title: title,
            textStyle: MyConstant().p1Style(),
          ),
        ),
      );
}
