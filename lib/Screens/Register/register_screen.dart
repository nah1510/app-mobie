import 'package:app/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/register_bloc.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/components/sign_background_light.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = "register";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  RegisterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = new RegisterBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Đăng ký'),
          backgroundColor: Colors.pink),
      backgroundColor: Color(0xFF333333),
      body: StreamBuilder<ApiResponse<String>>(
        stream: _bloc.registerStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                Future.delayed(
                  Duration.zero,
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    )
                  },
                );
                return Container();
              case Status.ERROR:
                Future.delayed(
                  Duration.zero,
                  () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: new Text("Lỗi"),
                        content: new Text(snapshot.data.message),
                        actions: [
                          FlatButton(
                            onPressed: () =>
                                Navigator.pop(context, true), // passing true
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  ).then(
                    (exit) {
                      if (exit == null) return;

                      if (exit) {
                        // user pressed Yes button
                      } else {
                        // user pressed No button
                      }
                    },
                  ),
                );
            }
          }
          return Stack(
            children: [
              SignBackgroundLight(),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ],
                          ),
                          child: Column(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Email',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Không hợp lệ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Mật khẩu',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Không hợp lệ';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //   border: Border(
                              //     bottom: BorderSide(
                              //       color: Colors.grey[400],
                              //     ),
                              //   ),
                              // ),
                              child: TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Họ và tên',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Không hợp lệ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
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
                              onPressed: registerBtnClick,
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: Text(
                                    "Đăng kí",
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void registerBtnClick() {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      UserModel user = new UserModel(
        name: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
      );
      _bloc.register(user);
    }
  }
}
