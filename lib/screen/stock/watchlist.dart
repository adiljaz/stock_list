
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_list/repository/getex.dart';

class AllStocksPage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Obx(() {
        if (homeController.savedStocks.isEmpty) {
          return Center(
            child: Text(
              'No stocks in your watchlist.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical, 
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                    ),
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.white30, width: 1),
                        verticalInside: BorderSide(color: Colors.white30, width: 1),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        top: BorderSide(color: Colors.white, width: 1),
                        bottom: BorderSide(color: Colors.white, width: 1),
                      ),
                      columnWidths: {
                        0: FixedColumnWidth(180),
                        1: FixedColumnWidth(70),
                        2: FixedColumnWidth(100) ,
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Price',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding( 
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Table Rows
                  Table(
                    border: TableBorder.all(color: Colors.grey[300]!),
                    columnWidths: {
                      0: FixedColumnWidth(180),
                      1: FixedColumnWidth(90),
                      2: FixedColumnWidth(70),
                    },
                    children: homeController.savedStocks.map((stock) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(stock.name),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '\$${stock.price}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    homeController.removeStock(homeController.savedStocks.indexOf(stock));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
  