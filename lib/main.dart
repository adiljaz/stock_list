import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:stock_list/home.dart';
import 'package:stock_list/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Hive.initFlutter(); 

  if (!Hive.isAdapterRegistered(StockWithAccessAdapter().typeId)) {
    Hive.registerAdapter(StockWithAccessAdapter()); 
  }

  await Hive.openBox<StockWithAccess>('watchlist'); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
