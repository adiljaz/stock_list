import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<StockWithAccess>> _futureStockResponse;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureStockResponse = fetchStockData();
  }

  Future<List<StockWithAccess>> fetchStockData({String? query}) async {
    final Uri uri;
    if (query != null && query.isNotEmpty) {
      uri = Uri.parse('https://api.twelvedata.com/symbol_search?symbol=$query&show_plan=true');
    } else {
      uri = Uri.parse('https://api.twelvedata.com/stocks?source=docs');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('API Response: $jsonResponse'); // Debug print

      if (jsonResponse['data'] is List) {
        return List<StockWithAccess>.from(jsonResponse['data'].map((item) => StockWithAccess.fromJson(item)));
      } else if (jsonResponse is List) {
        return List<StockWithAccess>.from(jsonResponse.map((item) => StockWithAccess.fromJson(item)));
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  void _performSearch(String query) {
    setState(() {
      _futureStockResponse = fetchStockData(query: query);
    });
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stocks...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StockWithAccess>>(
              future: _futureStockResponse,
              builder: (BuildContext context, AsyncSnapshot<List<StockWithAccess>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final stock = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            stock.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(stock.symbol),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                stock.exchange,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
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
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
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

class StockWithAccess {
  final String symbol;
  final String name;
  final String currency;
  final String exchange;
  final String micCode; 
  final String country;
  final String type;

  StockWithAccess({
    required this.symbol,
    required this.name,
    required this.currency, 
    required this.exchange,
    required this.micCode,
    required this.country,
    required this.type,
  });

  factory StockWithAccess.fromJson(Map<String, dynamic> json) {
    return StockWithAccess(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      currency: json['currency'] ?? '',
      exchange: json['exchange'] ?? '',
      micCode: json['mic_code'] ?? '',
      country: json['country'] ?? '',
      type: json['type'] ?? '',
    );
  }
} 