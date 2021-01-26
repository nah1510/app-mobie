import 'package:app/Screens/Home/home_screen.dart';
import 'package:app/Screens/Register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/Networking/api_responses.dart';
// ----- bloc
import 'package:app/BLoC/auth_bloc.dart';
import 'package:app/BLoC/device_bloc.dart';
// ----- model
import 'package:app/Models/auth_model.dart';
// ----- widgets
import 'package:app/Widget/Loading/loading_widget.dart';
// ----- screens
import 'package:app/components/sign_background_light.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthBloc _authBloc;
  DeviceBloc _deviceBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = new AuthBloc();
    _deviceBloc = new DeviceBloc();
    _authBloc.checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<ApiResponse<AuthModel>>(
          stream: _authBloc.authStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                case Status.COMPLETED:
                  if (snapshot.data.data.loggedIn) {
                    _deviceBloc.updateUser();
                    Future.delayed(
                      Duration.zero,
                      () => {
                        Navigator.pushReplacementNamed(
                          context,
                          HomeScreen.route,
                        )
                      },
                    );
                    return Container();
                  }
                  break;
                case Status.ERROR:
                  Future.delayed(
                    Duration.zero,
                    () => showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: new Text("Error"),
                          content: new Text((snapshot.data.message.toString() ==
                                  '"Unauthorized"')
                              ? "Wrong Info"
                              : snapshot.data.message),
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
              children: <Widget>[
                SignBackgroundLight(),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .2,
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email của bạn",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Invalid';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Invalid';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                      ),
                                    )
                                  ],
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
                                    onPressed: loginBtnClick,
                                    child: Container(
                                      height: 70,
                                      child: Center(
                                        child: Text(
                                          "ĐĂNG NHẬP",
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
                              Container(
                                margin: EdgeInsets.only(top: 40),
                                child: FlatButton(
                                  color: Colors.black.withOpacity(.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(RegisterScreen.route);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                      right: 40,
                                      left: 40,
                                    ),
                                    child: Text(
                                      "Đăng kí tài khoản",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.8),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  void loginBtnClick() {
    if (_formKey.currentState.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      _authBloc.login(email: email, password: password);
    }
  }
}
