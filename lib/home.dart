import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_list/getex.dart';
import 'package:stock_list/model.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Obx(() => TextField(
              controller: textController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search for a stock',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                suffixIcon: homeController.isSearching.value
                    ? IconButton(
                        icon: Icon(Icons.cancel, color: Colors.white),
                        onPressed: () {
                          homeController.cancelSearch();
                          textController.clear();
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          homeController.searchSymbols(textController.text);
                        },
                      ),
              ),
              onSubmitted: (value) {
                homeController.searchSymbols(value);
              },
            )),
          ),
          Expanded(
            child: Obx(() {
              if (homeController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (homeController.isSearching.value && homeController.searchResults.isEmpty) {
                return Center(child: Text('No stocks found.'));
              } else if (homeController.isSearching.value) {
                return ListView.builder(
                  itemCount: homeController.searchResults.length,
                  itemBuilder: (context, index) {
                    var stock = homeController.searchResults[index];
                    return StockCard(
                      stock: stock,
                      onAdd: () => homeController.addToSavedStocks(stock),
                      isInWatchlist: homeController.savedStocks.contains(stock),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  itemCount: homeController.allStocks.length,
                  itemBuilder: (context, index) {
                    var stock = homeController.allStocks[index];
                    return StockCard(
                      stock: stock,
                      onAdd: () => homeController.addToSavedStocks(stock),
                      isInWatchlist: homeController.savedStocks.contains(stock),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback onAdd;
  final bool isInWatchlist;

  const StockCard({
    Key? key,
    required this.stock,
    required this.onAdd,
    required this.isInWatchlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          stock.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(stock.symbol),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${double.parse(stock.price).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text(isInWatchlist ? 'Added' : 'Add', style: TextStyle(color: Colors.white)),
              onPressed: isInWatchlist ? null : onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: isInWatchlist ? Colors.grey : Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 