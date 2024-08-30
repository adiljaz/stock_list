import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_list/getex.dart';

class AllStocksPage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Delete', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: homeController.savedStocks.map((stock) => DataRow(
              cells: [
                DataCell(Text(stock.name)), 
                DataCell(Text('\$${stock.price}')),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      homeController.removeStock(homeController.savedStocks.indexOf(stock));
                    },
                  ),
                ),
              ],
            )).toList(),
          ),
        ),
      )),
    );
  }
} 