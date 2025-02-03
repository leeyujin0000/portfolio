import 'package:flutter/material.dart';
import 'package:laundry/account/account_page.dart';
import 'package:laundry/search/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '티끌모아빨래',
          style: TextStyle(
            fontFamily: 'MBC 1961',
            fontSize: 30,
            fontWeight: FontWeight.normal
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage())
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage())
            );
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 250,
                  height: 250,
                  child: Image(image: AssetImage('assets/images/laundry_search.png'))
              ),
              SizedBox(height: 16,),
              Text(
                  '내 주변 세탁소 찾기',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
