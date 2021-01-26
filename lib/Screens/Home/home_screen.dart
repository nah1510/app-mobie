import 'package:app/BLoC/product_list_bloc.dart';
import 'package:app/Models/product_list_model.dart';
import 'package:app/Screens/Product/product_detail_screen.dart';
import 'package:app/Widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ProductListBloc();
    _bloc.fetchProductLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchProductLists(),
        child: StreamBuilder<ApiResponse<ProductListModel>>(
          stream: _bloc.productListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ProductList(productList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchProductLists(),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}

class ProductList extends StatelessWidget {
  final ProductListModel productList;

  const ProductList({Key key, this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return new ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 1.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductScreen.route,
                        arguments: productList.productList[index].id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: 265,
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Image.network(
                                productList.productList[index].image,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.5)),
                                height: 70,
                                width: MediaQuery.of(context).size.width * 1,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 0, 12),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    productList.productList[index].tittle,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Roboto',
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0),
                                ),
                                width: MediaQuery.of(context).size.width * 1,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color:
                                            Colors.orange[800].withOpacity(.8),
                                        fontSize: 20,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: productList
                                              .productList[index].price
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
                                              color: Colors.red.withOpacity(.5),
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        );
      },
      itemCount: productList.productList.length,
    );
  }
}
