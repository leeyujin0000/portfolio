import 'package:flutter/material.dart';
import 'package:laundry/auth/login_page.dart';
import 'package:laundry/services/map_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:laundry/tab/tab_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool _authenticated = false;

  // Future<String> authenticate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? userEmail = prefs.getString('userEmail');
  //   print(userEmail);
  //   if (userEmail != null) {
  //     setState(() {
  //       _authenticated = true;
  //     });
  //     if (!mounted) return '';
  //     await context.read<UserServices>().getUserInfo(userEmail);
  //     if (!mounted) return '';
  //     await context.read<MapServices>().getUserLocation();
  //   }
  //   if (!mounted) return '';
  //   print(context.read<UserServices>().user.name);
  //   print('ready');
  //   return 'ready';
  // }

  Future<void> authenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userEmail = prefs.getString('userEmail');
    if (userEmail != null) {
      setState(() {
        _authenticated = true;
      });
      if (!mounted) return;
      await context.read<UserServices>().getUserInfo(userEmail);
      if (!mounted) return;
      await context.read<MapServices>().getUserLocation();
    }
  }

  @override
  void initState() {
    super.initState();
    authenticate().then((_){
      print('StartPageReady');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('userAuthenticated: $_authenticated');
    if (_authenticated) {
      return const TabPage();
    } else {
      return const LogInPage();
    }
    // return FutureBuilder(
    //     future: authenticate(),
    //     builder: (context, snapshot) {
    //       print(snapshot);
    //       if (snapshot.hasData) {
    //         if (_authenticated) {
    //           return const TabPage();
    //         } else {
    //           return const LogInPage();
    //         }
    //       } else {
    //         return const Scaffold(
    //           body: Center(
    //             child: CircularProgressIndicator(
    //               color: Colors.orangeAccent,
    //             ),
    //           ),
    //         );
    //       }
    //     }
    // );
  }
}
