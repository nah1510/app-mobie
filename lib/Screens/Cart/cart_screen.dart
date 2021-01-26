import 'package:app/BLoC/cart_bloc.dart';
import 'package:app/Models/cart_model.dart';
import 'package:app/Models/product_list_model.dart';
import 'package:app/Screens/Product/product_detail_screen.dart';
import 'package:app/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartScreen extends StatefulWidget {
  static const String route = "cart";
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CartBloc();
    _bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetch(),
        child: StreamBuilder<ApiResponse<CartModel>>(
          stream: _bloc.cartStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return Cart(cart: snapshot.data.data, bloc: _bloc);
                  break;
                case Status.ERROR:
                  Future.delayed(
                      Duration.zero,
                      () => showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: new Text("Error"),
                                content: new Text(
                                    (snapshot.data.message.toString() ==
                                            '"Unauthorized"')
                                        ? "Wrong Info"
                                        : snapshot.data.message),
                              );
                            },
                          ));
              }
            }
            return ErrWidget(
              errorMessage: snapshot.data.message,
              onRetryPressed: () => _bloc.fetch(),
            );
          },
        ),
      ),
    );
  }
}

class Cart extends StatelessWidget {
  final CartModel cart;
  final CartBloc bloc;
  const Cart({Key key, this.cart, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Container(
      color: Colors.grey.withOpacity(.2),
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * .2,
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .25,
                            right: MediaQuery.of(context).size.width * .2,
                            bottom: 30,
                          ),
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Text(
                            cart.details[index].product.tittle,
                            // cart.details[index].quantity.toString(), //so sp trong gio
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * .2,
                          width: MediaQuery.of(context).size.width * .2,
                          color: Colors.white,
                          padding: EdgeInsets.all(12),
                          child:
                              Image.network(cart.details[index].product.image),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * .3,
                            padding: EdgeInsets.all(12),
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  color: Colors.orange[800].withOpacity(.8),
                                  fontSize: 20,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: cart.details[index].product.price
                                        .toString()
                                        .toString(), // Đặt dữ liệu ở đây
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' đ',
                                    style: TextStyle(
                                        color: Colors.red.withOpacity(.5),
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * .35,
                            padding: EdgeInsets.fromLTRB(12, 12, 30, 12),
                            child: RichText(
                              text: TextSpan(
                                text: cart.details[index].quantity.toString() +
                                    'x',
                                style: TextStyle(
                                  color: Colors.orange[800].withOpacity(.8),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: cart.details.length,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(
                          color: Colors.orange[800].withOpacity(.8),
                          fontSize: 20,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                cart.price.toString(), // Đặt dữ liệu ở đây
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: ' đ',
                            style: TextStyle(
                                color: Colors.red.withOpacity(.5),
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: DefaultButton(
                    text: 'Check out',
                    press: () => {bloc.delete()},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
