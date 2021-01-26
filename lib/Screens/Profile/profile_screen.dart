import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/BLoC/user_bloc.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = "profile";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _bloc;
  //String _token;
  UserModel userDetail;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  @override
  void initState() {
    super.initState();
    //getToken();
    _bloc = UserBloc();
    _bloc.fetchUserDetail();
  }

  // Future<Null> getToken() async {
  //   _token = await _storage.read(key: "token");
  //   debugPrint("TOKEN: " + _token);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  userDetail = snapshot.data.data;
                  return UsertDetail(userDetail: userDetail);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
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

class UsertDetail extends StatelessWidget {
  final UserModel userDetail;

  const UsertDetail({Key key, this.userDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        //drawer: Container(width: 250, child: Drawer(child: DrawerNav())),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.orange[200],
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 40.0, right: 12.0),
                child: ListView(children: <Widget>[
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: FloatingActionButton(
                            child: Icon(Icons.edit),
                            backgroundColor: Colors.transparent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          radius: 75,
                          backgroundImage:
                              NetworkImage(userDetail.avatar.toString()),
                        )),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildTextField(
                            "Email", userDetail.email.toString(), false),
                        buildTextField(
                            "Họ tên", userDetail.name.toString(), false),
                        buildTextField(
                            "Số dư", userDetail.amount.toString(), false),
                      ],
                    ),
                  ),
                ]),
              ))
            ],
          ),
        ));
  }

  void logout() async {
    FlutterSecureStorage _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Container(
      margin: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: isPasswordTextField
                  ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.black87, fontSize: 18),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
