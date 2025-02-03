import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:laundry/auth/authentication.dart';
import 'package:laundry/services/map_services.dart';
import 'package:laundry/services/matching_services.dart';
import 'package:laundry/services/notification_services.dart';
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServices().fcmSetting();
  await NaverMapSdk.instance.initialize(clientId: 'id');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserServices()
        ),
        ChangeNotifierProvider(
            create: (context) => MapServices()
        ),
        ChangeNotifierProvider(
            create: (context) => PostServices()
        ),
        ChangeNotifierProvider(
            create: (context) => MatchingServices()
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Pretendard',
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black54
          ),
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            titleSpacing: 0,
            iconTheme: IconThemeData(
              color: Colors.black54
            ),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.black54,
              size: 30
            ),
            backgroundColor: Colors.white,
            shape: Border(
              bottom: BorderSide(
                color: Colors.black26,
              )
            ),
            elevation: 0
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
            )
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
            )
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent)
            )
          )
        ),
        home: const Authentication()
      ),
    );
  }
}