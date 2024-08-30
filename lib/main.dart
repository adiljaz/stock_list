import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_list/home.dart';
import 'package:stock_list/model.dart';
import 'package:stock_list/watchlist.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StockAdapter());
  await Hive.openBox<Stock>('stocks');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       title: 'Professional Stock App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _pages = [
    HomePage(),
    AllStocksPage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[_selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: _selectedIndex.value,
        onTap: (index) => _selectedIndex.value = index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Stocks'),
        ],
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
      )),
    );
  }
}