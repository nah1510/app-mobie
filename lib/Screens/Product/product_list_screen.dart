import 'package:app/BLoC/product_list_bloc.dart';
import 'package:app/Models/product_list_model.dart';
import 'package:flutter/material.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/services.dart';

class ProductListScreen extends StatefulWidget {
  static const String route = "products";
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
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
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('Trang chủ',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
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
    );
  }

  void createProduct() {}
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => null));
                        // ShowChuckyJoke(categoryList.categories[index])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 65,
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                productList.productList[index].tittle,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    color: Colors.white70),
                                textAlign: TextAlign.left,
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
            color: Colors.black54);
      },
      itemCount: productList.productList.length,
    );
  }
}
