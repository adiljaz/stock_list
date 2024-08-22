import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_list/model.dart'; // Adjust the import according to your project structure

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<StockResponse> _futureStockResponse;

  @override
  void initState() {
    super.initState();
    _futureStockResponse = fetchStockData();
  }

  Future<StockResponse> fetchStockData() async {
    final response = await http.get(Uri.parse('https://api.twelvedata.com/stocks'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        return StockResponse(
          data: List<StockWithAccess>.from(jsonResponse.map((item) => StockWithAccess.fromJson(item))),
          status: 'ok',
        );
      } else {
        return StockResponse.fromJson(jsonResponse);
      }
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Market'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: FutureBuilder<StockResponse>(
        future: _futureStockResponse,
        builder: (BuildContext context, AsyncSnapshot<StockResponse> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.data.length ?? 0,
              itemBuilder: (context, index) {
                final stock = snapshot.data?.data[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      stock?.name ?? 'N/A',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                   
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          stock!.symbol,    
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            // Add to watchlist functionality
                          }, 
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue[200],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
} 