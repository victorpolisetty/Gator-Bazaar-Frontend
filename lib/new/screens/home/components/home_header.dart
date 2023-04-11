import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../../../pages/favoritePage.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
          IconBtnWithCounter(

            svgSrc: "assets/icons/favorite.svg",
            //TODO: PUT BACK
            press: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favoritePageTab()),);
            },
            // press: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 0,
            press: () {
              showDialog(context: context,
                  builder: (_) => alertDialog(context),
              );
            },
          ),
        ],
      ),
    );
  }
  alertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("No Notifications!"),
      content: Text("Check back later :)"),
      actions: [
        CupertinoDialogAction(onPressed: () {
          Navigator.pop(context);
        },child: Text("Ok",style: TextStyle(fontWeight: FontWeight.bold))),

      ],
    );
  }
}
