import 'package:app/Screens/Cart/cart_screen.dart';
import 'package:app/Screens/Home/home_screen.dart';
import 'package:app/Screens/Product/product_detail_screen.dart';
import 'package:app/Screens/Product/product_list_screen.dart';
import 'package:app/Screens/Profile/profile_screen.dart';
import 'package:app/Screens/Register/register_screen.dart';
import 'package:flutter/material.dart';

// ----- bloc
import 'BLoC/device_bloc.dart';
import 'BLoC/bloc_provider.dart';

// ----- screen
import 'Screens/Login/login_screen.dart';

void main() => runApp(BlocProvider(bloc: DeviceBloc(), child: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ProductScreen.route: (context) => ProductScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        accentColor: Colors.pinkAccent,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.route:
            return MaterialPageRoute(builder: (_) => LoginScreen());
            break;
          case HomeScreen.route:
            return MaterialPageRoute(builder: (_) => HomeScreen());
            break;
          case RegisterScreen.route:
            return MaterialPageRoute(builder: (_) => RegisterScreen());
            break;
          case ProfileScreen.route:
            return MaterialPageRoute(builder: (_) => ProfileScreen());
            break;
          // case CardScreen.route:
          //   return MaterialPageRoute(builder: (_) => CardScreen());
          //   break;
          case ProductScreen.route:
            return MaterialPageRoute(builder: (_) => ProductScreen());
            break;
          case ProductListScreen.route:
            return MaterialPageRoute(builder: (_) => ProductListScreen());
            break;
          case CartScreen.route:
            return MaterialPageRoute(builder: (_) => CartScreen());
            break;
          default:
            return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      },
    );
  }
}
