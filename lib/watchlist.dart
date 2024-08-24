// watchlist.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WatchList extends StatefulWidget {
  const WatchList({Key? key}) : super(key: key);

  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late Box<StockWithAccess> watchlistBox;

  @override
  void initState() {
    super.initState();
    watchlistBox = Hive.box<StockWithAccess>('watchlist');
    _updateStockPrices();
  }

  Future<void> _updateStockPrices() async {
    for (var i = 0; i < watchlistBox.length; i++) {
      var stock = watchlistBox.getAt(i);
      if (stock != null) {
        await _fetchLatestPrice(stock);
      }
    }
  }

  Future<void> _fetchLatestPrice(StockWithAccess stock) async {
    final apiKey = 'YOUR_ALPHAVANTAGE_API_KEY'; // Replace with your API key
    final url = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${stock.symbol}&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final price = data['Global Quote']['05. price']; 
        if (price != null) {
          // stock.price = price; // Assuming you've added a 'price' field to StockWithAccess
          await watchlistBox.put(stock.symbol, stock);
        }     
      }
    } catch (e) {
      print('Error fetching price for ${stock.symbol}: $e');
    }
  }

  void _deleteStock(String symbol) {
    watchlistBox.delete(symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        backgroundColor: Colors.blue[800],
      ),
      body: ValueListenableBuilder(
        valueListenable: watchlistBox.listenable(),
        builder: (context, Box<StockWithAccess> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('Your watchlist is empty'));
          }
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      children: [
                        _buildTableHeader('Company'),
                        _buildTableHeader('Price'),
                      
                      ],
                    ),
                    ...box.values.map((stock) => TableRow(
                      children: [
                        _buildTableCell(stock.name),
                        _buildTableCell(stock.symbol?? 'N/A'), 
                      ],
                    )).toList(),
                  ],
                ),
              ),
            ],
          ); 
        },
      ),
    ); 
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(dynamic content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: content is Widget ? content : Text(
        content.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }
} 