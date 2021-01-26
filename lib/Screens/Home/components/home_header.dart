import 'package:app/Screens/Product/product_detail_screen.dart';
import 'package:app/components/icon_btn_with_counter.dart';
import 'package:flutter/material.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchField(),
            IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg", press: () {}
                // => Navigator.pushNamed(context, ProductScreen.route),
                ),
          ],
        ),
      ),
    );
  }
}
