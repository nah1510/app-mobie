import 'package:flutter/material.dart';

class SignBackgroundLight extends StatelessWidget {
  const SignBackgroundLight({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Image.asset(
            'assets/images/living_room.jpg',
            fit: BoxFit.cover,
          ),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
        ),
        Container(
          color: Colors.black.withOpacity(.3),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
        ),
        // Container(
        //   margin: EdgeInsets.only(
        //     left: MediaQuery.of(context).size.width * .2,
        //     top: MediaQuery.of(context).size.height * .4,
        //   ),
        //   width: MediaQuery.of(context).size.width * .2,
        //   height: MediaQuery.of(context).size.height * .5,
        //   child: Image.asset('assets/images/light.png'),
        // ),
        // Container(
        //   margin: EdgeInsets.only(
        //     left: MediaQuery.of(context).size.width * .7,
        //   ),
        //   width: MediaQuery.of(context).size.width * .2,
        //   height: MediaQuery.of(context).size.height * .3,
        //   child: Image.asset('assets/images/light.png'),
        // ),
        // Container(
        //   margin: EdgeInsets.only(
        //     left: MediaQuery.of(context).size.width * .3,
        //     top: MediaQuery.of(context).size.height * .6,
        //   ),
        //   width: MediaQuery.of(context).size.width * .4,
        //   height: MediaQuery.of(context).size.height * .5,
        //   child: Image.asset('assets/images/light.png'),
        // ),
        // Container(
        //   margin: EdgeInsets.only(
        //     left: MediaQuery.of(context).size.width * .7,
        //     top: MediaQuery.of(context).size.height * .4,
        //   ),
        //   width: MediaQuery.of(context).size.width * .2,
        //   height: MediaQuery.of(context).size.height * .5,
        //   child: Image.asset('assets/images/light.png'),
        // ),
        // Container(
        //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .1),
        //   width: MediaQuery.of(context).size.width * .2,
        //   height: MediaQuery.of(context).size.height * .7,
        //   child: Image.asset('assets/images/light.png'),
        // ),
        // Container(
        //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .3),
        //   width: MediaQuery.of(context).size.width * .4,
        //   height: MediaQuery.of(context).size.height * .4,
        //   child: Image.asset('assets/images/light.png'),
        // ),
      ],
    );
  }
}
