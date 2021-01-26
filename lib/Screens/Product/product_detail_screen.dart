import 'package:app/BLoC/cart_bloc.dart';
import 'package:app/BLoC/product_bloc.dart';
import 'package:app/Models/image_model.dart';
import 'package:app/Models/product_model.dart';
import 'package:app/components/default_button.dart';
import 'package:app/size_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductScreen extends StatefulWidget {
  static const String route = "product";
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductBloc _bloc;

  //String _token;
  ProductModel productDetail;
  String status = '';
  String base64Image;
  String errMessage = 'Error Uploading Image';
  @override
  void initState() {
    super.initState();
    _bloc = ProductBloc();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    _bloc.fetchproduct(args);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết sản phẩm',
        ),
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchproduct(args),
        child: StreamBuilder<ApiResponse<ProductModel>>(
          stream: _bloc.productStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  productDetail = snapshot.data.data;
                  return ProductDetail(
                      productDetail: productDetail, bloc: _bloc);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchproduct(args),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final ProductModel productDetail;
  final ProductBloc bloc;
  const ProductDetail({Key key, this.productDetail, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductCarousel(productDetail: productDetail),
              ProductItemInfo(productDetail: productDetail, bloc: bloc),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItemInfo extends StatelessWidget {
  const ProductItemInfo({Key key, this.productDetail, this.bloc})
      : super(key: key);
  final ProductModel productDetail;
  final ProductBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60),
      padding: EdgeInsets.fromLTRB(30, 60, 30, 40),
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 17,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: RatingBarIndicator(
                  rating: 5, // get Rating bỏ vào đây
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 40.0,
                  direction: Axis
                      .horizontal, // cho rating nằm ngang, verical sẽ nằm dọc
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  productDetail.tittle,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(
                  top: 50,
                  right: 100,
                ),
                child: Text(
                  productDetail.description,
                  style: TextStyle(
                    color: Colors.black.withOpacity(.7),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 4,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 40,
                bottom: 20,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: 'Giá thành sản phẩm : ',
                    style: TextStyle(
                      color: Colors.orange[800].withOpacity(.8),
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: productDetail.price
                            .toString(), // Đặt dữ liệu ở đây
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: ' đ',
                        style: TextStyle(
                            color: Colors.red.withOpacity(.5), fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange[800].withOpacity(.7),
                    Colors.orange[400].withOpacity(.7),
                  ],
                ),
              ),
              child: Center(
                child: FlatButton(
                  onPressed: () => {bloc.add(productDetail.id)},
                  child: Container(
                    height: 70,
                    child: Center(
                      child: Text(
                        "Thêm vào giỏ hàng",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductModel productDetail;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 400,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 600),
          autoPlayCurve: Curves.fastOutSlowIn,
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          viewportFraction: 1.0),
      items: productDetail.images
          .map((item) => Container(
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            item.url,
                            fit: BoxFit.fill,
                            width: 14200.0,
                          ),
                        ],
                      )),
                ),
              ))
          .toList(),
    );
  }
}
