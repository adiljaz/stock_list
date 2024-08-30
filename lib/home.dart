import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'watchlist.dart';
import 'model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<StockWithAccess>> _futureStockResponse;
  final TextEditingController _searchController = TextEditingController();
  late Box<StockWithAccess> watchlistBox;
  int _currentIndex = 0;

  @override 
  void initState() { 
    super.initState();
    _futureStockResponse = fetchStockData();
    openWatchlistBox();
  }

  Future<List<StockWithAccess>> fetchStockData({String? query}) async {
    final Uri uri;
    if (query != null && query.isNotEmpty) {
      uri = Uri.parse(
          'https://api.twelvedata.com/symbol_search?symbol=$query&show_plan=true');
    } else {
      uri = Uri.parse('https://api.twelvedata.com/stocks?source=docs');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('API Response: $jsonResponse'); // Debug print

      if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
        return (jsonResponse['data'] as List)
            .map((item) => StockWithAccess.fromJson(item)) 
            .toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((item) => StockWithAccess.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  Future<void> openWatchlistBox() async {
    watchlistBox = await Hive.openBox<StockWithAccess>('watchlist');
  }

  void _addToWatchlist(StockWithAccess stock) async {
    await watchlistBox.put(stock.symbol, stock);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${stock.name} added to watchlist')),
    );
  }

  void _handleSearch(String query) {
    setState(() {
      _futureStockResponse = fetchStockData(query: query);
    });
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search stocks...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _handleSearch(_searchController.text),
              ),
              border: OutlineInputBorder(),
            ),
            onSubmitted: _handleSearch,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<StockWithAccess>>(
            future: _futureStockResponse,
            builder: (BuildContext context, AsyncSnapshot<List<StockWithAccess>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No stocks found'));
              }

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
                     
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            stock.symbol,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () => _addToWatchlist(stock),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Stock Market' : 'Watchlist'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: _currentIndex == 0 ? _buildHomeContent() : WatchList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.blue[800], 
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue[200],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Watchlist'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}